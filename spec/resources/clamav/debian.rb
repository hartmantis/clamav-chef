# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav'

shared_context 'resources::clamav::debian' do
  include_context 'resources::clamav'

  let(:defaults) do
    {
      clamd_config: {
        bytecode_timeout: 60_000,
        database_directory: '/var/lib/clamav',
        extended_detection_info: true,
        local_socket: '/var/run/clamav/clamd.ctl',
        log_file: '/var/log/clamav/clamav.log',
        log_file_max_size: 0,
        log_rotate: true,
        log_time: true,
        max_connection_queue_length: 15,
        max_threads: 12,
        read_timeout: 180,
        self_check: 3600,
        send_buf_timeout: 200,
        user: 'clamav'
      },
      freshclam_config: {
        checks: 24,
        connect_timeout: 30,
        database_mirror: %w[db.local.clamav.net database.clamav.net],
        database_owner: 'clamav',
        log_file_max_size: 0,
        log_rotate: true,
        log_time: true,
        max_attempts: 5,
        notify_clamd: '/etc/clamav/clamd.conf',
        update_log_file: '/var/log/clamav/freshclam.log'
      }
    }
  end

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
