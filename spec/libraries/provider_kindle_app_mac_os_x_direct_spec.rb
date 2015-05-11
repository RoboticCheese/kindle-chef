# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_kindle_app_mac_os_x_direct'

describe Chef::Provider::KindleApp::MacOsX::Direct do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::KindleApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    let(:remote_path) { 'http://example.com/Kindle.dmg' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return(remote_path)
    end

    it 'installs the DMG package' do
      p = provider
      expect(p).to receive(:dmg_package).with('Kindle').and_yield
      expect(p).to receive(:source).with(remote_path)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remote_path' do
    let(:path) { 'http://example.com/Kindle.dmg' }
    let(:response) { { 'location' => path } }

    before(:each) do
      allow(Net::HTTP).to receive(:get_response)
        .with(URI('https://www.amazon.com/kindlemacdownload'))
        .and_return(response)
    end

    it 'returns the redirect path' do
      p = provider
      expect(p.send(:remote_path)).to eq(path)
      expect(p.instance_variable_get(:@remote_path)).to eq(path)
    end
  end
end
