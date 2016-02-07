require_relative '../../../spec_helper'

describe 'resource_clamav_service_clamd::ubuntu::14_04' do
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav_service_clamd', platform: 'ubuntu', version: '14.04'
    )
  end
  let(:converge) do
    runner.converge("resource_clamav_service_clamd_test::#{action}")
  end

  context 'the default action (:nothing)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'does nothing with the clamd service' do
      expect(chef_run.service('clamav-daemon')).to eq(nil)
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }
    cached(:chef_run) { converge }

    it 'enables the clamd service' do
      expect(chef_run).to enable_service('clamav-daemon')
    end
  end

  context 'the :disable action' do
    let(:action) { :disable }
    cached(:chef_run) { converge }

    it 'disables the clamd service' do
      expect(chef_run).to disable_service('clamav-daemon')
    end
  end

  context 'the :start action' do
    let(:action) { :start }
    cached(:chef_run) { converge }

    it 'starts the clamd service' do
      expect(chef_run).to start_service('clamav-daemon')
    end
  end

  context 'the :stop action' do
    let(:action) { :stop }
    cached(:chef_run) { converge }

    it 'stops the clamd service' do
      expect(chef_run).to stop_service('clamav-daemon')
    end
  end
end
