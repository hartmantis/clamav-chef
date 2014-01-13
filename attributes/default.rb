# -*- encoding: utf-8 -*-
#
# Cookbook Name:: clamav
# Attributes:: default
#
# Copyright 2012-2014, Jonathan Hartman
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

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
