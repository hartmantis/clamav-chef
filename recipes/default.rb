# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Recipe:: default
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

version = node['clamav']['version']
dev = node['clamav']['dev']
clamd_config = node['clamav']['clamd']['config']
freshclam_config = node['clamav']['freshclam']['config']
enable_clamd = node['clamav']['clamd']['enabled']
enable_freshclam = node['clamav']['freshclam']['enabled']

clamav 'default' do
  version version unless version.nil?
  dev dev unless dev.nil?
  clamd_config clamd_config unless clamd_config.nil?
  freshclam_config freshclam_config unless freshclam_config.nil?
  enable_clamd enable_clamd unless enable_clamd.nil?
  enable_freshclam enable_freshclam unless enable_freshclam.nil?
end
