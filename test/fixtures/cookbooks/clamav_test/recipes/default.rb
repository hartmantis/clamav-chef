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
# main.cvd and daily.cvd, either as a cookbook_file or remote_file resource.
directory('/var/lib/clamav') { recursive true }
clamav_update 'prep' do
  source(if File.exist?(File.expand_path('../../files/main.cvd', __FILE__))
           File.expand_path('../../files/main.cvd', __FILE__)
         else
           :direct
         end)
end
# The intentionally delete the bytecode.cvd so we still put the cookbook's
# wait logic through its paces.
file('/var/lib/clamav/bytecode.cvd') { action :delete }

include_recipe 'clamav'
