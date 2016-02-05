# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: logging
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

require 'etc'

include_recipe 'logrotate'

log_files = [
  node['clamav']['clamd']['log_file'],
  node['clamav']['freshclam']['update_log_file']
].keep_if { |f| f }.uniq

log_files.map { |f| File.dirname(f) }.uniq.each do |d|
  directory d do
    owner node['clamav']['user']
    group node['clamav']['group']
    recursive true
    action :create
  end
end

log_files.each do |f|
  file f do
    owner node['clamav']['user']
    group node['clamav']['group']
    action :create
  end
end

node['clamav']['clamd']['log_file'] && logrotate_app('clamav') do
  cookbook 'logrotate'
  path node['clamav']['clamd']['log_file']
  frequency node['clamav']['clamd']['logrotate_frequency']
  rotate node['clamav']['clamd']['logrotate_rotations']
  create "644 #{node['clamav']['user']} #{node['clamav']['group']}"
end

node['clamav']['freshclam']['update_log_file'] && logrotate_app('freshclam') do
  cookbook 'logrotate'
  path node['clamav']['freshclam']['update_log_file']
  frequency node['clamav']['freshclam']['logrotate_frequency']
  rotate node['clamav']['freshclam']['logrotate_rotations']
  create "644 #{node['clamav']['user']} #{node['clamav']['group']}"
end
