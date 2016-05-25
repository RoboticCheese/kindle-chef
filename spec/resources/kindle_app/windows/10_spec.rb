require_relative '../../../spec_helper'

describe 'resource_kindle_app::windows::10' do
  let(:name) { 'default' }
  %i(source action).each { |i| let(i) { nil } }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'kindle_app', platform: 'windows', version: '10'
    ) do |node|
      %i(name source action).each do |p|
        node.set['resource_kindle_app_test'][p] = send(p) unless send(p).nil?
      end
    end
  end
  let(:converge) { runner.converge('resource_kindle_app_test') }

  before(:each) do
    allow(Net::HTTP).to receive(:get_response).with(
      URI('https://www.amazon.com/kindlepcdownload')
    ).and_return('location' => 'https://example.com/kindle')
  end

  context 'the default action (:install)' do
    let(:action) { nil }

    context 'the default install method (:direct)' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it 'installs the Kindle app' do
        expect(chef_run).to install_windows_package('Amazon Kindle').with(
          source: 'https://example.com/kindle',
          installer_type: :nsis
        )
      end
    end
  end
end
