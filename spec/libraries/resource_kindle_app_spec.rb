# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_kindle_app'

describe Chef::Resource::KindleApp do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      exp = :kindle_app
      expect(resource.instance_variable_get(:@resource_name)).to eq(exp)
    end
  end

  describe '#app_name' do
    it 'uses the correct app name' do
      expect(resource.app_name).to eq('Kindle')
    end
  end

  describe '#bundle_id' do
    it 'uses the correct bundle ID' do
      expect(resource.bundle_id).to eq('com.amazon.Kindle')
    end
  end
end
