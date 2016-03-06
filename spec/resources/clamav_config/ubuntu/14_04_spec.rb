require_relative '../../../spec_helper'

describe 'resource_clamav_config::ubuntu::14_04' do
  let(:action) { nil }
  let(:service) { nil }
  let(:config) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav_config', platform: 'ubuntu', version: '14.04'
    ) do |node|
      node.set['clamav'][service]['config'] = config unless config.nil?
    end
  end
  let(:converge) do
    runner.converge("resource_clamav_config_test::#{action}_#{service}")
  end

  context 'the default action (:create)' do
    let(:content) { 'somecontent' }
    let(:action) { :default }

    shared_examples_for 'any service' do
      it 'ensures the ClamAV conf directory exists' do
        expect(chef_run).to create_directory('/etc/clamav')
          .with(owner: 'clamav', group: 'clamav', recursive: true)
      end
    end

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it_behaves_like 'any service'

      it 'creates the clamd config file' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
        EOH
        expect(chef_run).to create_file('/etc/clamav/clamd.conf')
          .with(owner: 'clamav', group: 'clamav', content: expected)
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it_behaves_like 'any service'

      it 'creates the freshclam config file' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
        EOH
        expect(chef_run).to create_file('/etc/clamav/freshclam.conf')
          .with(owner: 'clamav', group: 'clamav', content: expected)
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

  context 'the :delete action' do
    let(:action) { :delete }
    cached(:chef_run) { converge }

    context 'the clamd service' do
      let(:service) { 'clamd' }
      cached(:chef_run) { converge }

      it 'deletes the clamd config file' do
        expect(chef_run).to delete_file('/etc/clamav/clamd.conf')
      end
    end

    context 'the freshclam service' do
      let(:service) { 'freshclam' }
      cached(:chef_run) { converge }

      it 'deletes the freshclam config file' do
        expect(chef_run).to delete_file('/etc/clamav/freshclam.conf')
      end
    end
  end
end
