# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_mapping
#
# Copyright 2012-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/version'
require 'chef/platform/provider_mapping'
require_relative 'provider_clamav_app'
require_relative 'provider_clamav_app_debian'
require_relative 'provider_clamav_service'

if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12')
  Chef::Platform.set(resource: :clamav_app,
                     platform_family: :debian,
                     provider: Chef::Provider::ClamavApp::Debian)
  Chef::Platform.set(resource: :clamav_service,
                     platform_family: :debian,
                     provider: Chef::Provider::ClamavService)
end
