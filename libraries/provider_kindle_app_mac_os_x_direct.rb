# Encoding: UTF-8
#
# Cookbook Name:: kindle
# Library:: provider_kindle_app_mac_os_x_direct
#
# Copyright 2015 Jonathan Hartman
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
require_relative 'provider_kindle_app_mac_os_x'

class Chef
  class Provider
    class KindleApp < Provider::LWRPBase
      class MacOsX < KindleApp
        # A Chef provider for OS X installs via direct download.
        #
        # @author Jonathan Hartman <j@p4nt5.com>
        class Direct < MacOsX
          URL ||= 'http://www.amazon.com/kindlemacdownload'

          private

          #
          # Download and install the package. The dmg cookbook declares a
          # remote_file resource inline, so we can do the download and install
          # in one resource here.
          #
          # (see KindleApp#install!)
          #
          def install!
            s = remote_path
            dmg_package 'Kindle' do
              source s
              action :install
            end
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
