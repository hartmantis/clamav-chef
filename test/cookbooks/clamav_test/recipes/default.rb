# Encoding: UTF-8
#
# Cookbook Name:: clamav_test
# Recipe:: default
#
# Copyright 2013-2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Compiler is needed to install Cucumber for the acceptance tests
include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'build-essential'

# Ensure rsyslog is installed and running, regardless of whether the build
# environment is a Vagrant box or a Docker container with no init system.
package 'rsyslog'
file '/etc/rsyslog.conf' do
  content <<-EOH.gsub(/^ {4}/, '')
    $ModLoad imuxsock
    $WorkDirectory /var/lib/rsyslog
    $ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
    $OmitLocalLogging off
    *.info;mail.none;authpriv.none;cron.none /var/log/messages
    authpriv.* /var/log/secure
    mail.* -/var/log/maillog
    cron.* /var/log/cron
    *.emerg :omusrmsg:*
    uucp,news.crit /var/log/spooler
    local7.* /var/log/boot.log
  EOH
  only_if do
    node['platform_family'] == 'rhel' && \
      node['platform_version'].to_i >= 7 && \
      File.open('/proc/1/cmdline').read.start_with?('/usr/sbin/sshd')
  end
end
execute 'rsyslogd' do
  ignore_failure true
end

include_recipe 'clamav'
