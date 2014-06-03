# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: install_rpm
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

include_recipe 'yum-epel'
include_recipe "#{cookbook_name}::services"

%w(clamav clamav-db clamd).each do |pkg|
  yum_package pkg do
    action :install
    version node['clamav']['version'] if node['clamav']['version']
    if File.exist?('/etc/yum.repos.d/rpmforge.repo')
      options '--disablerepo=rpmforge'
    end
    # Give it an arch or YUM will try to install both i386 and x86_64 versions
    arch node['kernel']['machine']
    if node['clamav']['clamd']['enabled']
      notifies :restart,
               "service[#{node['clamav']['clamd']['service']}]"
    end
    if node['clamav']['freshclam']['enabled']
      notifies :restart,
               "service[#{node['clamav']['freshclam']['service']}]"
    end
  end
end

yum_package 'clamav-devel' do
  action :install
  version node['clamav']['version'] if node['clamav']['version']
  arch node['kernel']['machine']
  only_if { node['clamav']['dev_package'] }
end

template "/etc/init.d/#{node['clamav']['clamd']['service']}" do
  source 'clamd.init.rhel.erb'
  mode '0755'
  action :create
  variables(
    clamd_conf: "#{node['clamav']['conf_dir']}/clamd.conf",
    clamd_pid: node['clamav']['clamd']['pid_file'],
    clamd_bin_dir: '/usr/sbin'
  )
end

template "/etc/init.d/#{node['clamav']['freshclam']['service']}" do
  source 'freshclam.init.rhel.erb'
  mode '0755'
  action :create
  variables(
    freshclam_conf: "#{node['clamav']['conf_dir']}/freshclam.conf",
    freshclam_pid: node['clamav']['freshclam']['pid_file'],
    freshclam_bin_dir: '/usr/bin'
  )
end

user 'clam' do
  action :remove
  not_if { node['clamav']['user'] == 'clam' }
end
