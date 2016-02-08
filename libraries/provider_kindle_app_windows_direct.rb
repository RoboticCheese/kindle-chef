# Encoding: UTF-8
#
# Cookbook Name:: kindle
# Library:: provider_kindle_app_windows_direct
#
# Copyright 2015-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'net/http'
require 'chef/provider/lwrp_base'
require_relative 'provider_kindle_app'
require_relative 'provider_kindle_app_windows'

class Chef
  class Provider
    class KindleApp < Provider::LWRPBase
      class Windows < KindleApp
        # A Chef provider for Windows installs via direct download.
        #
        # @author Jonathan Hartman <j@p4nt5.com>
        class Direct < Windows
          URL ||= 'http://www.amazon.com/kindlepcdownload'.freeze

          private

          #
          # (see KindleApp#install!)
          #
          def install!
            download_package
            install_package
          end

          #
          # Download the installer via a remote_file resource.
          #
          def download_package
            s = remote_path
            remote_file download_path do
              source s
              action :create
              only_if { !::File.exist?(PATH) }
            end
          end

          #
          # Run the installer via a windows_package resource.
          #
          def install_package
            s = download_path
            windows_package 'Amazon Kindle' do
              source s
              installer_type :nsis
              action :install
            end
          end

          #
          # Construct a path to download the installer to.
          #
          # @return [String]
          #
          def download_path
            ::File.join(Chef::Config[:file_cache_path],
                        ::File.basename(remote_path))
          end

          #
          # Follow the redirect redirect from URL to get the .dmg file download
          # path. Save it as an instance variable so we only have to hit
          # Amazon's web server once.
          #
          # @return [String]
          #
          def remote_path
            @remote_path ||= Net::HTTP.get_response(URI(URL))['location']
          end
        end
      end
    end
  end
end
