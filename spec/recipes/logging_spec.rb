# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::logging' do
  let(:log_dir) { '/var/log/clamav' }
  let(:clamd_log_file) { "#{log_dir}/clamd.log" }
  let(:freshclam_log_file) { "#{log_dir}/freshclam.log" }
  let(:attributes) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'includes the logrotate recipe' do
      expect(chef_run).to include_recipe('logrotate')
    end
  end

  context 'an entirely default node' do
    it_behaves_like 'any node'

    it 'creates the log directory' do
      expect(chef_run).to create_directory(log_dir).with(
        owner: 'clamav',
        group: 'clamav',
        recursive: true
      )
    end

    it 'creates the log files' do
      [clamd_log_file, freshclam_log_file].each do |f|
        expect(chef_run).to create_file(f).with(
          owner: 'clamav',
          group: 'clamav'
        )
      end
    end

    it 'defines a logrotate_app for clamav' do
      expect(chef_run).to create_logrotate_app('clamav').with(
        cookbook: 'logrotate',
        path: clamd_log_file,
        frequency: 'daily',
        rotate: 7,
        create: '644 clamav clamav'
      )
    end

    it 'defines a logrotate_app for freshclam' do
      expect(chef_run).to create_logrotate_app('freshclam').with(
        cookbook: 'logrotate',
        path: freshclam_log_file,
        frequency: 'daily',
        rotate: 7,
        create: '644 clamav clamav'
      )
    end

    context 'a node set to log to syslog instead of files' do
      let(:attributes) do
        {
          clamav: {
            clamd: {
              log_file: false, log_syslog: 'yes', log_facility: 'f1'
            },
            freshclam: {
              update_log_file: false, log_syslog: 'yes', syslog_facility: 'f2'
            }
          }
        }
      end

      it_behaves_like 'any node'

      it 'does not create the log directory' do
        expect(chef_run).to_not create_directory(log_dir)
      end

      it 'does not define a logrotate_app for clamav' do
        expect(chef_run).to_not create_logrotate_app('clamav')
      end

      it 'does not define a logrotate_app for freshclam' do
        expect(chef_run).to_not create_logrotate_app('freshclam')
      end
    end
  end
end
