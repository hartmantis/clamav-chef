#
# Cookbook Name:: clamav
# Recipe:: freshclam
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

service node["clamav"]["freshclam"]["service"]

template "#{node["clamav"]["conf_dir"]}/freshclam.conf" do
  owner node["clamav"]["user"]
  group node["clamav"]["group"]
  source "freshclam.conf.erb"
  mode "0644"
  action :create
  variables(
    :freshclam => node["clamav"]["freshclam"],
    :database_directory => node["clamav"]["database_directory"],
    :database_owner => node["clamav"]["user"],
    :allow_supplementary_groups =>
      node["clamav"]["allow_supplementary_groups"],
    :notify_clamd => node["clamav"]["clamd"]["enabled"] ?
      File.expand_path("#{node["clamav"]["conf_dir"]}/clamd.conf") : nil,
    :bytecode => node["clamav"]["bytecode"]
  )
  if node["clamav"]["freshclam"]["enabled"]
    notifies :restart, "service[#{node["clamav"]["freshclam"]["service"]}]",
      :delayed
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
