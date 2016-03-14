# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'
require_relative '../../libraries/resource_clamav'
require_relative '../../libraries/resource_clamav_app'
require_relative '../../libraries/resource_clamav_config'
require_relative '../../libraries/resource_clamav_cron'
require_relative '../../libraries/resource_clamav_service'

describe :provider_mapping do
  let(:chef_version) { nil }
  let(:platform) { nil }
  let(:resource) { nil }
  let(:provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::Clamav.new('default', nil)
    )
  end
  let(:app_provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::ClamavApp.new('default', nil)
    )
  end
  let(:config_provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::ClamavConfig.new('clamd', nil)
    )
  end
  let(:cron_provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::ClamavCron.new('default', nil)
    )
  end
  let(:service_provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::ClamavService.new('clamd', nil)
    )
  end

  before(:each) do
    Chef::VERSION.replace(chef_version) unless chef_version.nil?
  end

  shared_examples_for 'Chef 12' do
    it 'does not set any other providers' do
      expect(Chef::Platform).to_not receive(:set)
      load(File.expand_path('../../../libraries/provider_mapping.rb',
                            __FILE__))
    end
  end

  context 'Ubuntu' do
    let(:platform) { { platform: 'ubuntu', version: '14.04' } }

    context 'Chef 12' do
      let(:chef_version) { '12.4.1' }

      it_behaves_like 'Chef 12'
    end

    context 'Chef 11' do
      let(:chef_version) { '11.16.4' }

      it 'sets up old-style provider mappings' do
        allow(Chef::Log).to receive(:warn)
        expect(Chef::Platform).to receive(:set).at_least(1).times
          .and_call_original
        load(File.expand_path('../../../libraries/provider_mapping.rb',
                              __FILE__))
        expect(provider).to eq(Chef::Provider::Clamav)
        expect(app_provider).to eq(Chef::Provider::ClamavApp::Debian)
        expect(config_provider).to eq(Chef::Provider::ClamavConfig)
        expect(cron_provider).to eq(Chef::Provider::ClamavCron)
        expect(service_provider).to eq(Chef::Provider::ClamavService)
      end
    end
  end

  context 'Debian' do
    let(:platform) { { platform: 'debian', version: '8.1' } }

    context 'Chef 12' do
      let(:chef_version) { '12.4.1' }

      it_behaves_like 'Chef 12'
    end

    context 'Chef 11' do
      let(:chef_version) { '11.16.4' }

      it 'sets up old-style provider mappings' do
        allow(Chef::Log).to receive(:warn)
        expect(Chef::Platform).to receive(:set).at_least(1).times
          .and_call_original
        load(File.expand_path('../../../libraries/provider_mapping.rb',
                              __FILE__))
        expect(provider).to eq(Chef::Provider::Clamav)
        expect(app_provider).to eq(Chef::Provider::ClamavApp::Debian)
        expect(config_provider).to eq(Chef::Provider::ClamavConfig)
        expect(cron_provider).to eq(Chef::Provider::ClamavCron)
        expect(service_provider).to eq(Chef::Provider::ClamavService)
      end
    end
  end
end
