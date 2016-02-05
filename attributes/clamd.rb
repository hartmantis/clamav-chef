# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Attributes:: clamd
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
default['clamav']['clamd']['enabled'] = false

# OS-Specific Options
case node['platform_family']
when 'rhel'
  default['clamav']['clamd']['service'] = 'clamd'
when 'debian'
  default['clamav']['clamd']['service'] = 'clamav-daemon'
end

# Options - clamd.conf
default['clamav']['clamd']['log_file'] = '/var/log/clamav/clamd.log'
default['clamav']['clamd']['logrotate_frequency'] = 'daily'
default['clamav']['clamd']['logrotate_rotations'] = 7
default['clamav']['clamd']['log_file_unlock'] = 'no'
default['clamav']['clamd']['log_file_max_size'] = '10M'
default['clamav']['clamd']['log_time'] = 'yes'
default['clamav']['clamd']['log_clean'] = 'no'
default['clamav']['clamd']['log_syslog'] = 'no'
default['clamav']['clamd']['log_facility'] = nil
default['clamav']['clamd']['log_verbose'] = 'yes'
default['clamav']['clamd']['extended_detection_info'] = 'yes'
default['clamav']['clamd']['pid_file'] = '/var/run/clamav/clamd.pid'
default['clamav']['clamd']['temporary_directory'] = '/tmp'
default['clamav']['clamd']['official_database_only'] = 'no'
default['clamav']['clamd']['local_socket'] = '/tmp/clamd'
default['clamav']['clamd']['local_socket_group'] = nil
default['clamav']['clamd']['local_socket_mode'] = nil
default['clamav']['clamd']['fix_stale_socket'] = 'yes'
default['clamav']['clamd']['tcp_socket'] = nil
default['clamav']['clamd']['tcp_addr'] = nil
default['clamav']['clamd']['max_connection_queue_length'] = 200
default['clamav']['clamd']['stream_max_length'] = '25M'
default['clamav']['clamd']['stream_min_port'] = '1024'
default['clamav']['clamd']['stream_max_port'] = '2048'
default['clamav']['clamd']['max_threads'] = '2'
default['clamav']['clamd']['read_timeout'] = '120'
default['clamav']['clamd']['command_read_timeout'] = '5'
default['clamav']['clamd']['send_buf_timeout'] = '500'
default['clamav']['clamd']['max_queue'] = '100'
default['clamav']['clamd']['idle_timeout'] = '30'
default['clamav']['clamd']['exclude_paths'] = [
  '^/proc/', '^/sys/', '^/dev/', '^/var/log/clamav/'
]
default['clamav']['clamd']['max_directory_recursion'] = '25'
default['clamav']['clamd']['follow_directory_symlinks'] = 'no'
default['clamav']['clamd']['follow_file_symlinks'] = 'no'
default['clamav']['clamd']['cross_filesystems'] = 'yes'
default['clamav']['clamd']['self_check'] = '600'
default['clamav']['clamd']['virus_event'] = nil
default['clamav']['clamd']['exit_on_oom'] = 'no'
default['clamav']['clamd']['foreground'] = 'no'
default['clamav']['clamd']['debug'] = 'no'
default['clamav']['clamd']['leave_temporary_files'] = 'no'
default['clamav']['clamd']['detect_pua'] = 'no'
default['clamav']['clamd']['exclude_puas'] = []
default['clamav']['clamd']['include_puas'] = []
default['clamav']['clamd']['algorithmic_detection'] = 'yes'
default['clamav']['clamd']['scan_pe'] = 'yes'
default['clamav']['clamd']['scan_elf'] = 'yes'
default['clamav']['clamd']['detect_broken_executables'] = 'no'
default['clamav']['clamd']['scan_ole2'] = 'yes'
default['clamav']['clamd']['ole2_block_macros'] = 'no'
default['clamav']['clamd']['scan_pdf'] = 'yes'
default['clamav']['clamd']['scan_mail'] = 'yes'
default['clamav']['clamd']['scan_partial_messages'] = 'no'
default['clamav']['clamd']['phishing_signatures'] = 'yes'
default['clamav']['clamd']['phishing_scan_urls'] = 'yes'
default['clamav']['clamd']['phishing_always_block_ssl_mismatch'] = 'no'
default['clamav']['clamd']['phishing_always_block_cloak'] = 'no'
default['clamav']['clamd']['heuristic_scan_precedence'] = 'no'
default['clamav']['clamd']['structured_data_detection'] = 'no'
default['clamav']['clamd']['structured_min_credit_card_count'] = nil
default['clamav']['clamd']['structured_min_ssn_count'] = nil
default['clamav']['clamd']['structured_ssn_format_normal'] = nil
default['clamav']['clamd']['structured_ssn_format_stripped'] = nil
default['clamav']['clamd']['scan_html'] = 'yes'
default['clamav']['clamd']['scan_archive'] = 'yes'
default['clamav']['clamd']['archive_block_encrypted'] = 'no'
default['clamav']['clamd']['max_scan_size'] = '100M'
default['clamav']['clamd']['max_file_size'] = '25M'
default['clamav']['clamd']['max_recursion'] = '25'
default['clamav']['clamd']['max_files'] = '10000'
default['clamav']['clamd']['clamuko_scanner_count'] = nil
default['clamav']['clamd']['clamuko_max_file_size'] = nil
default['clamav']['clamd']['clamuko_scan_on_open'] = nil
default['clamav']['clamd']['clamuko_scan_on_close'] = nil
default['clamav']['clamd']['clamuko_scan_on_exec'] = nil
default['clamav']['clamd']['clamuko_include_paths'] = []
default['clamav']['clamd']['clamuko_exclude_paths'] = []
default['clamav']['clamd']['clamuko_exclude_uids'] = []
default['clamav']['clamd']['bytecode_security'] = 'TrustSigned'
default['clamav']['clamd']['bytecode_timeout'] = '5000'
