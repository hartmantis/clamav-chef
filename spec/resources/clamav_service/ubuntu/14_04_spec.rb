require_relative '../../../spec_helper'

describe 'resource_clamav_service::ubuntu::14_04' do
  let(:action) { nil }
  let(:service) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav_service', platform: 'ubuntu', version: '14.04'
    )
  end
  let(:converge) do
    runner.converge("resource_clamav_service_test::#{action}_#{service}")
  end

  context 'the default action (:nothing)' do
    let(:action) { :default }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'does nothing with the clamd service' do
        expect(chef_run.service('clamav-daemon')).to eq(nil)
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'does nothing with the freshclam service' do
        expect(chef_run.service('clamav-freshclam')).to eq(nil)
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end

    context 'the garbage service' do
      let(:service) { 'garbage' }
      cached(:chef_run) { converge }

      it 'raises an error' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'enables the clamd service' do
        expect(chef_run).to enable_service('clamav-daemon')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'enables the freshclam service' do
        expect(chef_run).to enable_service('clamav-freshclam')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end
  end

  context 'the :disable action' do
    let(:action) { :disable }
    cached(:chef_run) { converge }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'disables the clamd service' do
        expect(chef_run).to disable_service('clamav-daemon')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'disables the freshclam service' do
        expect(chef_run).to disable_service('clamav-freshclam')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end
  end

  context 'the :start action' do
    let(:action) { :start }
    cached(:chef_run) { converge }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'starts the clamd service' do
        expect(chef_run).to start_service('clamav-daemon')
      end

      it 'conditionally executes freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to run_execute(exe)
          .with(command: 'freshclam', creates: '/var/lib/clamav/main.cvd')
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'starts the freshclam service' do
        expect(chef_run).to start_service('clamav-freshclam')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end
  end

  context 'the :stop action' do
    let(:action) { :stop }
    cached(:chef_run) { converge }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'stops the clamd service' do
        expect(chef_run).to stop_service('clamav-daemon')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'stops the freshclam service' do
        expect(chef_run).to stop_service('clamav-freshclam')
      end

      it 'does not execute freshclam' do
        exe = 'Ensure virus definitions exist so clamd can start'
        expect(chef_run).to_not run_execute(exe)
      end
    end
  end
end
