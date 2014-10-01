# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: freshclam
#
# Copyright 2012-2014, Jonathan Hartman
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

include_recipe "#{cookbook_name}::services"

platform_family = node['platform_family']
supp_groups = node['clamav']['allow_supplementary_groups']

directory node['clamav']['database_directory'] do
  owner node['clamav']['user']
  group node['clamav']['group']
  recursive true
end

if node['clamav']['clamd']['enabled']
  notify = File.expand_path("#{node['clamav']['conf_dir']}/clamd.conf")
else
  notify = nil
end

template "#{node['clamav']['conf_dir']}/freshclam.conf" do
  owner node['clamav']['user']
  group node['clamav']['group']
  source 'freshclam.conf.erb'
  mode '0644'
  action :create
  variables(
    freshclam: node['clamav']['freshclam'],
    database_directory: node['clamav']['database_directory'],
    database_owner: node['clamav']['user'],
    allow_supplementary_groups: supp_groups,
    notify_clamd: notify,
    bytecode: node['clamav']['bytecode']
  )
  if node['clamav']['freshclam']['enabled']
    notifies :restart, "service[#{node['clamav']['freshclam']['service']}]",
             :delayed
  end
  if !node['clamav']['freshclam']['enabled'] || platform_family == 'debian'
    notifies :run, 'execute[freshclam]', :immediately
  end
end

execute 'freshclam' do
  command 'freshclam'
  action :nothing
end
