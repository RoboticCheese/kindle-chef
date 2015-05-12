# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_kindle_app_mac_os_x_app_store'

describe Chef::Provider::KindleApp::MacOsX::AppStore do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::KindleApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    before(:each) do
      [:include_recipe, :mac_app_store_app].each do |r|
        allow_any_instance_of(described_class).to receive(r)
      end
    end

    it 'opens the Mac App Store' do
      p = provider
      expect(p).to receive(:include_recipe).with('mac-app-store')
      p.send(:install!)
    end

    it 'installs the app from the App Store' do
      p = provider
      expect(p).to receive(:mac_app_store_app).with('Kindle').and_yield
      expect(p).to receive(:bundle_id).with('com.amazon.Kindle')
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end
end
