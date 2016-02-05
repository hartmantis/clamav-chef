# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: clamav_scan
#
# Copyright 2012-2016, Jonathan Hartman
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

cookbook_file node['clamav']['scan']['script']['path'] do
  source 'clamav-scan.sh'
  owner node['clamav']['user']
  group node['clamav']['group']
  mode '0555'
  only_if { node['clamav']['scan']['script']['enable'] }
end

script_path = node['clamav']['scan']['script']['path']
min_dirs = node['clamav']['scan']['minimal']['dirs']
full_dirs = node['clamav']['scan']['full']['dirs']

cron_d 'clamav_minimal_scan' do
  minute node['clamav']['scan']['minimal']['minute']
  hour node['clamav']['scan']['minimal']['hour']
  weekday node['clamav']['scan']['minimal']['weekday']
  user node['clamav']['scan']['user']
  mailto node['clamav']['scan']['mailto']
  command "#{script_path} #{min_dirs}"
  only_if { node['clamav']['scan']['minimal']['enable'] }
end

cron_d 'clamav_full_scan' do
  minute node['clamav']['scan']['full']['minute']
  hour node['clamav']['scan']['full']['hour']
  weekday node['clamav']['scan']['full']['weekday']
  user node['clamav']['scan']['user']
  mailto node['clamav']['scan']['mailto']
  command "#{script_path} #{full_dirs}"
  only_if { node['clamav']['scan']['full']['enable'] }
end
