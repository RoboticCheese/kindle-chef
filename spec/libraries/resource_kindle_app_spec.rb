# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_kindle_app'

describe Chef::Resource::KindleApp do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:resource) { described_class.new(name, run_context) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      exp = :kindle_app
      expect(resource.resource_name).to eq(exp)
    end

    it 'sets the correct supported actions' do
      expected = [:nothing, :install]
      expect(resource.allowed_actions).to eq(expected)
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:install])
    end

    it 'sets the installed status to nil' do
      expect(resource.installed).to eq(nil)
    end
  end

  [:installed, :installed?].each do |m|
    describe "##{m}" do
      context 'default unknown installed status' do
        it 'returns nil' do
          expect(resource.send(m)).to eq(nil)
        end
      end

      context 'app installed' do
        let(:resource) do
          r = super()
          r.instance_variable_set(:@installed, true)
          r
        end

        it 'returns true' do
          expect(resource.send(m)).to eq(true)
        end
      end

      context 'app not installed' do
        let(:resource) do
          r = super()
          r.instance_variable_set(:@installed, false)
          r
        end

        it 'returns false' do
          expect(resource.send(m)).to eq(false)
        end
      end
    end
  end
end
