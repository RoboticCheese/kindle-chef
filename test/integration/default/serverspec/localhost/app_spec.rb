# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Kindle app' do
  describe package('com.amazon.Kindle'), if: os[:family] == 'darwin' do
    it 'is installed' do
      expect(subject).to be_installed.by(:pkgutil)
    end
  end

  describe file('/Applications/Kindle.app'), if: os[:family] == 'darwin' do
    it 'is present on the filesystem' do
      expect(subject).to be_directory
    end
  end
end
