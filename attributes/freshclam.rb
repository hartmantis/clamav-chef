# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Attributes:: default
#
# Copyright 2012-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install-Time Options
default['clamav']['freshclam']['enabled'] = false

# OS-Specific Options
case node['platform_family']
when 'rhel'
  default['clamav']['freshclam']['service'] = 'freshclam'
when 'debian'
  default['clamav']['freshclam']['service'] = 'clamav-freshclam'
end

# Options - freshclam.conf
default['clamav']['freshclam']['update_log_file'] = '/var/log/clamav/' \
  'freshclam.log'
default['clamav']['freshclam']['logrotate_frequency'] = 'daily'
default['clamav']['freshclam']['logrotate_rotations'] = 7
default['clamav']['freshclam']['log_file_max_size'] = '1M'
default['clamav']['freshclam']['log_time'] = 'no'
default['clamav']['freshclam']['log_verbose'] = 'no'
default['clamav']['freshclam']['log_syslog'] = 'no'
default['clamav']['freshclam']['log_facility'] = nil
default['clamav']['freshclam']['pid_file'] = '/var/run/clamav/freshclam.pid'
default['clamav']['freshclam']['dns_database_info'] = 'current.cvd.clamav.net'
default['clamav']['freshclam']['database_mirrors'] = ['database.clamav.net']
default['clamav']['freshclam']['max_attempts'] = '3'
default['clamav']['freshclam']['scripted_updates'] = 'yes'
default['clamav']['freshclam']['compress_local_database'] = 'no'
default['clamav']['freshclam']['database_custom_urls'] = []
default['clamav']['freshclam']['checks'] = '12'
default['clamav']['freshclam']['http_proxy_server'] = nil
default['clamav']['freshclam']['http_proxy_port'] = nil
default['clamav']['freshclam']['http_proxy_username'] = nil
default['clamav']['freshclam']['http_proxy_password'] = nil
default['clamav']['freshclam']['http_user_agent'] = nil
default['clamav']['freshclam']['local_ip_address'] = nil
default['clamav']['freshclam']['on_update_execute'] = nil
default['clamav']['freshclam']['on_error_execute'] = nil
default['clamav']['freshclam']['on_outdated_execute'] = nil
default['clamav']['freshclam']['foreground'] = 'no'
default['clamav']['freshclam']['debug'] = 'no'
default['clamav']['freshclam']['connect_timeout'] = '30'
default['clamav']['freshclam']['receive_timeout'] = '30'
default['clamav']['freshclam']['test_databases'] = 'yes'
default['clamav']['freshclam']['submit_detection_stats'] = nil
default['clamav']['freshclam']['detection_stats_country'] = nil
default['clamav']['freshclam']['detection_stats_host_id'] = nil
default['clamav']['freshclam']['safe_browsing'] = nil
default['clamav']['freshclam']['extra_databases'] = []

# Other
default['clamav']['freshclam']['rhel_cron_disable'] = true
default['clamav']['freshclam']['skip_initial_run'] = false
