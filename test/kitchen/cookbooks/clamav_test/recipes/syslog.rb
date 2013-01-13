#
# Cookbook Name:: clamav_test
# Recipe:: syslog
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

node.set["clamav"]["clamd"]["enabled"] = true
node.set["clamav"]["clamd"]["log_file"] = nil
node.set["clamav"]["clamd"]["log_syslog"] = "yes"
node.set["clamav"]["clamd"]["syslog_facility"] = "local7"

node.set["clamav"]["freshclam"]["enabled"] = true
node.set["clamav"]["freshclam"]["update_log_file"] = nil
node.set["clamav"]["freshclam"]["log_syslog"] = "yes"
node.set["clamav"]["freshclam"]["syslog_facility"] = "local7"

include_recipe "#{@cookbook_name}::default"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
