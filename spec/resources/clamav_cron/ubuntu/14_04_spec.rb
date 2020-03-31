require_relative '../../../spec_helper'

describe 'resource_clamav_cron::ubuntu::14_04' do
  %i[
    minute
    hour
    day
    month
    weekday
    paths
    action
  ].each do |a|
    let(a) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav_cron', platform: 'ubuntu', version: '14.04'
    ) do |node|
      %i[minute hour day month weekday].each do |a|
        node.set['clamav']['cron'][a] = send(a)
      end
      node.set['clamav']['cron']['paths'] = paths unless paths.nil?
    end
  end
  let(:converge) { runner.converge("resource_clamav_cron_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'configures the ClamAV cron job' do
        expect(chef_run).to create_cron_d('clamav-default')
          .with(minute: minute,
                hour: hour,
                day: day,
                month: month,
                weekday: weekday,
                command: "clamscan #{paths ? paths.join(' ') : '/'}")
      end
    end

    context 'all default attributes' do
      cached(:chef_run) { converge }

      it 'raises an error' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end

    context 'a nightly cron job' do
      let(:minute) { 0 }
      let(:hour) { 0 }
      let(:day) { '*' }
      let(:month) { '*' }
      let(:weekday) { '*' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a cron job with custom scan paths' do
      let(:minute) { 0 }
      let(:hour) { 0 }
      let(:day) { '*' }
      let(:month) { '*' }
      let(:weekday) { '*' }
      let(:paths) { %w[/var /home /lib] }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :delete action' do
    let(:action) { :delete }
    cached(:chef_run) { converge }

    it 'deletes the ClamAV cron job' do
      expect(chef_run).to delete_cron_d('clamav-default')
    end
  end
end
