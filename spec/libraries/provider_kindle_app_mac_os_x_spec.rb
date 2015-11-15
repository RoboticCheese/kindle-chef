# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_kindle_app_mac_os_x'

describe Chef::Provider::KindleApp::MacOsX do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::KindleApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the correct filesystem path' do
      expect(described_class::PATH).to eq('/Applications/Kindle.app')
    end
  end
end
