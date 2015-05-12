# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_kindle_app_windows'

describe Chef::Provider::KindleApp::Windows do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::KindleApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the correct filesystem path' do
      expected = File.expand_path('/Program Files (x86)/Amazon/Kindle')
      expect(described_class::PATH).to eq(expected)
    end
  end
end
