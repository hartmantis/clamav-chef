# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: clamd
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

include_recipe "#{cookbook_name}::services"

supp_groups = node['clamav']['allow_supplementary_groups']
template "#{node['clamav']['conf_dir']}/clamd.conf" do
  owner node['clamav']['user']
  group node['clamav']['group']
  source 'clamd.conf.erb'
  mode '0644'
  action :create
  variables(
    clamd: node['clamav']['clamd'],
    database_directory: node['clamav']['database_directory'],
    user: node['clamav']['user'],
    allow_supplementary_groups: supp_groups,
    bytecode: node['clamav']['bytecode']
  )
  if node['clamav']['clamd']['enabled']
    notifies :restart, "service[#{node['clamav']['clamd']['service']}]"
  end
end
