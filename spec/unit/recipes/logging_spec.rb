# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav::logging' do
  let(:log_dir) { '/var/log/clamav' }
  let(:clamd_log_file) { "#{log_dir}/clamd.log" }
  let(:freshclam_log_file) { "#{log_dir}/freshclam.log" }
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'an entirely default node' do
    it 'includes the logrotate recipe' do
      expect(chef_run).to include_recipe('logrotate')
    end

    it 'creates the logrotate directory' do
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
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
