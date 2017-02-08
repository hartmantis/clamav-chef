# encoding: utf-8
# frozen_string_literal: true

apt_update 'periodic'

# Delete the policy file that blocks postinst scripts on Docker containers.
file('/usr/sbin/policy-rc.d') { action :delete }

# Ensure rsyslog is installed and running so we can smoke test ClamAV logging
# configs.
package 'rsyslog'
service 'rsyslog' do
  action %i(enable start)
end

# Speed up the build by circumventing the initial freshclam run and pulling in
# main.cvd, either as a cookbook_file or remote_file resource.
directory('/var/lib/clamav') { recursive true }
if File.exist?(::File.expand_path('../../files/main.cvd', __FILE__))
  cookbook_file '/var/lib/clamav/main.cvd'
else
  remote_file '/var/lib/clamav/main.cvd' do
    source 'http://database.clamav.net/main.cvd'
  end
end

include_recipe 'clamav'
