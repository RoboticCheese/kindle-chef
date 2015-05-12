# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe :provider_mapping do
  let(:platform) { nil }
  let(:app_provider) do
    Chef::Platform.platforms[platform][:default][:kindle_app]
  end

  context 'Mac OS X' do
    let(:platform) { :mac_os_x }

    it 'uses the Mac AppStore provider' do
      expect(app_provider).to eq(Chef::Provider::KindleApp::MacOsX::AppStore)
    end
  end

  context 'Windows' do
    let(:platform) { :windows }

    it 'uses the Windows Direct provider' do
      expect(app_provider).to eq(Chef::Provider::KindleApp::Windows::Direct)
    end
  end

  context 'Ubuntu' do
    let(:platform) { :ubuntu }

    it 'returns no app provider' do
      expect(app_provider).to eq(nil)
    end
  end
end
