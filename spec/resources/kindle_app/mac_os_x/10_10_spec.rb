require_relative '../../../spec_helper'

describe 'resource_kindle_app::mac_os_x::10_10' do
  let(:name) { 'default' }
  %i(source action).each { |i| let(i) { nil } }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'kindle_app', platform: 'mac_os_x', version: '10.10'
    ) do |node|
      %i(name source action).each do |p|
        node.set['resource_kindle_app_test'][p] = send(p) unless send(p).nil?
      end
    end
  end
  let(:converge) { runner.converge('resource_kindle_app_test') }

  before(:each) do
    allow(Net::HTTP).to receive(:get_response).with(
      URI('https://www.amazon.com/kindlemacdownload')
    ).and_return('location' => 'https://example.com/kindle')
  end

  context 'the default action (:install)' do
    let(:action) { nil }

    context 'the default install method (:app_store)' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it 'includes the mac-app-store recipe' do
        expect(chef_run).to include_recipe('mac-app-store')
      end

      it 'installs the Kindle app' do
        expect(chef_run).to install_mac_app_store_app('Kindle')
      end
    end

    context 'the :direct install method' do
      let(:source) { :direct }
      cached(:chef_run) { converge }

      it 'installs the Kindle app' do
        expect(chef_run).to install_dmg_package('Kindle').with(
          source: 'https://example.com/kindle'
        )
      end
    end
  end

  context 'the :upgrade' do
    let(:action) { :upgrade }

    context 'the default install method (:app_store)' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it 'includes the mac-app-store recipe' do
        expect(chef_run).to include_recipe('mac-app-store')
      end

      it 'upgrades the Kindle app' do
        expect(chef_run).to upgrade_mac_app_store_app('Kindle')
      end
    end

    context 'the :direct install method' do
      let(:source) { :direct }
      cached(:chef_run) { converge }

      it 'raises an error' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
