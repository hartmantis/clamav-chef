# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: install_rpm
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

include_recipe 'yum-epel'
include_recipe "#{cookbook_name}::services"

yum_options = []
package_list = case node['platform']
               when 'amazon'
                 yum_options << '--disablerepo=epel'
                 %w(clamav clamav-update clamd)
               else
                 if node['platform_version'].to_i >= 7
                   %w(clamav-server clamav clamav-update)
                 else
                   %w(clamav clamav-db clamd)
                 end
               end

package_list.each do |pkg|
  yum_package pkg do
    action :install
    version node['clamav']['version'] if node['clamav']['version']
    options yum_options.join(' ')

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

template '/etc/sysconfig/freshclam' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'freshclam.sysconfig.erb'
  action :create
  variables(
    rhel_cron_disable: node['clamav']['freshclam']['rhel_cron_disable']
  )
end

user 'clam' do
  action :remove
  not_if { node['clamav']['user'] == 'clam' }
end
