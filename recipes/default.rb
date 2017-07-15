# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: clamav
# Recipe:: default
#
# Copyright 2012-2017, Jonathan Hartman
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

attrs = node['clamav']

clamav 'default' do
  version attrs['version'] unless attrs['version'].nil?
  dev attrs['dev'] unless attrs['dev'].nil?
  clamd_config attrs['clamd']['config'] unless attrs['clamd']['config'].nil?
  unless attrs['freshclam']['config'].nil?
    freshclam_config attrs['freshclam']['config']
  end
  enable_clamd attrs['clamd']['enabled'] unless attrs['clamd']['enabled'].nil?
  unless attrs['freshclam']['enabled'].nil?
    enable_freshclam attrs['freshclam']['enabled']
  end
end
