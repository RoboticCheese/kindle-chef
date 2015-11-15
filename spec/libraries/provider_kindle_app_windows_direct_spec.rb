# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_kindle_app_windows_direct'

describe Chef::Provider::KindleApp::Windows::Direct do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::KindleApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'URL' do
    it 'returns the correct URL' do
      expected = 'http://www.amazon.com/kindlepcdownload'
      expect(described_class::URL).to eq(expected)
    end
  end

  describe '#install!' do
    before(:each) do
      [:download_package, :install_package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'downloads the package' do
      p = provider
      expect(p).to receive(:download_package)
      p.send(:install!)
    end

    it 'installs the package' do
      p = provider
      expect(p).to receive(:install_package)
      p.send(:install!)
    end
  end

  describe '#download_package' do
    let(:remote_path) { 'http://example.com/Kindle.exe' }
    let(:download_path) { '/tmp/Kindle.exe' }

    before(:each) do
      [:remote_path, :download_path].each do |m|
        allow_any_instance_of(described_class).to receive(m)
          .and_return(send(m))
      end
    end

    it 'downloads the Windows package' do
      p = provider
      expect(p).to receive(:remote_file).with(download_path).and_yield
      expect(p).to receive(:source).with(remote_path)
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:download_package)
    end
  end

  describe '#install_package' do
    let(:download_path) { '/tmp/Kindle.exe' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return(download_path)
    end

    it 'installs the Windows package' do
      p = provider
      expect(p).to receive(:windows_package).with('Amazon Kindle').and_yield
      expect(p).to receive(:source).with(download_path)
      expect(p).to receive(:installer_type).with(:nsis)
      expect(p).to receive(:action).with(:install)
      p.send(:install_package)
    end
  end

  describe '#download_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/Kindle.exe')
    end

    it 'returns the correct path' do
      expect(provider.send(:download_path)).to eq(
        "#{Chef::Config[:file_cache_path]}/Kindle.exe"
      )
    end
  end

  describe '#remote_path' do
    let(:path) { 'http://example.com/Kindle.exe' }
    let(:response) { { 'location' => path } }

    before(:each) do
      allow(Net::HTTP).to receive(:get_response)
        .with(URI('http://www.amazon.com/kindlepcdownload'))
        .and_return(response)
    end

    it 'returns the redirect path' do
      p = provider
      expect(p.send(:remote_path)).to eq(path)
      expect(p.instance_variable_get(:@remote_path)).to eq(path)
    end
  end
end
