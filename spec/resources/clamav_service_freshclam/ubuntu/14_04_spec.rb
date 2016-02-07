require_relative '../../../spec_helper'

describe 'resource_clamav_service_freshclam::ubuntu::14_04' do
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'clamav_service_freshclam',
                             platform: 'ubuntu',
                             version: '14.04')
  end
  let(:converge) do
    runner.converge("resource_clamav_service_freshclam_test::#{action}")
  end

  context 'the default action (:nothing)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'does nothing with the freshclam service' do
      expect(chef_run.service('clamav-freshclam')).to eq(nil)
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }
    cached(:chef_run) { converge }

    it 'enables the freshclam service' do
      expect(chef_run).to enable_service('clamav-freshclam')
    end
  end

  context 'the :disable action' do
    let(:action) { :disable }
    cached(:chef_run) { converge }

    it 'disables the freshclam service' do
      expect(chef_run).to disable_service('clamav-freshclam')
    end
  end

  context 'the :start action' do
    let(:action) { :start }
    cached(:chef_run) { converge }

    it 'starts the freshclam service' do
      expect(chef_run).to start_service('clamav-freshclam')
    end
  end

  context 'the :stop action' do
    let(:action) { :stop }
    cached(:chef_run) { converge }

    it 'stops the freshclam service' do
      expect(chef_run).to stop_service('clamav-freshclam')
    end
  end
end
