# encoding: utf-8
# frozen_string_literal: true

apt_update 'periodic'

# Ensure rsyslog is installed and running so we can smoke test ClamAV logging
# configs.
package 'rsyslog'
service 'rsyslog' do
  action %i(enable start)
end

# Speed up Travis builds by dropping in some shared .cvd files instead of
# downloading them from the DB server on each test platform.
if ::File.exist?(::File.expand_path('../../files/main.cvd', __FILE__))
  directory '/var/lib/clamav' do
    recursive true
  end

  %w(main.cvd daily.cvd bytecode.cvd).each do |f|
    cookbook_file ::File.join('/var/lib/clamav', f)
  end
end

include_recipe 'clamav'
