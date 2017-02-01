# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav_config'

shared_context 'resources::clamav_config::debian' do
  include_context 'resources::clamav_config'

  let(:defaults) do
    {
      conf_dir: '/etc/clamav',
      user: 'clamav',
      group: 'clamav'
    }
  end

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'

    context 'the :create action' do
      context 'a clamd resource' do
        let(:name) { 'clamd' }

        context 'all default properties' do
          it 'renders the default clamd config' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              BytecodeTimeout 60000
              DatabaseDirectory /var/lib/clamav
              ExtendedDetectionInfo true
              LocalSocket /var/run/clamav/clamd.ctl
              LogFile /var/log/clamav/clamav.log
              LogFileMaxSize 0
              LogRotate true
              LogTime true
              MaxConnectionQueueLength 15
              MaxThreads 12
              ReadTimeout 180
              SelfCheck 3600
              SendBufTimeout 200
              User clamav
            EOH
            expect(chef_run).to create_file('/etc/clamav/clamd.conf')
              .with(owner: 'clamav', group: 'clamav', content: expected)
          end
        end
      end

      context 'a freshclam resource' do
        let(:name) { 'freshclam' }

        context 'all default properties' do
          it 'renders the default freshclam config' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              Checks 24
              ConnectTimeout 30
              DatabaseMirror db.local.clamav.net
              DatabaseMirror database.clamav.net
              DatabaseOwner clamav
              LogFileMaxSize 0
              LogRotate true
              LogTime true
              MaxAttempts 5
              NotifyClamd /etc/clamav/clamd.conf
              UpdateLogFile /var/log/clamav/freshclam.log
            EOH
            expect(chef_run).to create_file('/etc/clamav/freshclam.conf')
              .with(owner: 'clamav', group: 'clamav', content: expected)
          end
        end
      end
    end
  end
end
