# -*- encoding: utf-8 -*-
#
# Cookbook Name:: clamav
# Recipe:: clamd_service
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

directory File.dirname(node['clamav']['clamd']['pid_file']) do
  owner node['clamav']['user']
  group node['clamav']['group']
  recursive true
  action :create
end

service node['clamav']['clamd']['service'] do
  supports status: true, restart: true
  action node['clamav']['clamd']['enabled'] ? [:enable, :start] :
    [:stop, :disable]
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
