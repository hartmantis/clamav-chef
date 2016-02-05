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

# Shared and OS-Specific Options
default['clamav']['version'] = nil
case node['platform_family']
when 'rhel'
  default['clamav']['conf_dir'] = '/etc'
when 'debian'
  default['clamav']['conf_dir'] = '/etc/clamav'
end
default['clamav']['dev_package'] = false
default['clamav']['database_directory'] = '/var/lib/clamav'
default['clamav']['user'] = 'clamav'
default['clamav']['group'] = 'clamav'
default['clamav']['allow_supplementary_groups'] = 'no'
default['clamav']['bytecode'] = 'yes'

default['clamav']['scan']['script']['path'] = '/usr/local/bin/clamav-scan.sh'
default['clamav']['scan']['script']['enable'] = false
default['clamav']['scan']['minimal']['minute'] = '42'
default['clamav']['scan']['minimal']['hour'] = '0'
default['clamav']['scan']['minimal']['weekday'] = '1-6'
default['clamav']['scan']['minimal']['dirs'] = '/bin /sbin /usr/bin ' \
  '/usr/sbin /usr/local/bin /usr/local/sbin /etc /root /opt /home'
default['clamav']['scan']['minimal']['enable'] = false
default['clamav']['scan']['full']['minute'] = '42'
default['clamav']['scan']['full']['hour'] = '0'
default['clamav']['scan']['full']['weekday'] = '0'
default['clamav']['scan']['full']['dirs'] = '/'
default['clamav']['scan']['full']['enable'] = false
default['clamav']['scan']['user'] = 'root'
default['clamav']['scan']['mailto'] = 'example@example.com'
