# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: poise_services
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

c_service = node['clamav']['clamd']['service']
c_enabled = node['clamav']['clamd']['enabled']
poise_service c_service do
  command "/usr/sbin/clamd -c #{node['clamav']['conf_dir']}/clamd.conf"
  action :nothing
end

f_service = node['clamav']['freshclam']['service']
f_enabled = node['clamav']['freshclam']['enabled']
poise_service f_service do
  command "/usr/bin/freshclam -d --config-file=#{node['clamav']['conf_dir']}/freshclam.conf}"
  action :nothing
end

ruby_block 'dummy poise_service notification block' do
  block do
    Chef::Log.info('Dispatching poise_service notifications...')
  end
  if c_enabled
    notifies :enable, "poise_service[#{c_service}]"
    notifies :start, "poise_service[#{c_service}]"
  else
    notifies :stop, "poise_service[#{c_service}]"
    notifies :disable, "poise_service[#{c_service}]"
  end
  if f_enabled
    notifies :enable, "poise_service[#{f_service}]"
    notifies :start, "poise_service[#{f_service}]"
  else
    notifies :stop, "poise_service[#{f_service}]"
    notifies :disable, "poise_service[#{f_service}]"
  end
end
