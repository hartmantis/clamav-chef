#
# Cookbook Name:: clamav_test
# Recipe:: default
#
# Copyright 2012-2013, Jonathan Hartman
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

# Need to plant the recipes in the run_list individually, or minitest-handler
# won't trace all of them
include_recipe "clamav::default"
case node["platform_family"]
when "rhel"
  include_recipe "clamav::install_rpm"
when "debian"
  include_recipe "clamav::install_deb"
end
include_recipe "clamav::users"
include_recipe "clamav::logging"
include_recipe "clamav::clamd"
include_recipe "clamav::freshclam"
include_recipe "clamav::clamd_service"
include_recipe "clamav::freshclam_service"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
