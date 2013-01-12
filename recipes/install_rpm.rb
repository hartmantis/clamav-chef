#
# Cookbook Name:: clamav
# Recipe:: install_rpm
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

include_recipe "yum::epel"

service node["clamav"]["clamd"]["service"]
service node["clamav"]["freshclam"]["service"]

["clamav", "clamav-db", "clamd"].each do |pkg|
  package pkg do
    action :install
    version node["clamav"]["version"] if node["clamav"]["version"]
    options "--disablerepo=rpmforge" if 
      File.exist?("/etc/yum.repos.d/rpmforge.repo")
    if node["clamav"]["clamd"]["enabled"]
      notifies :restart,
        "service[#{node["clamav"]["clamd"]["service"]}]"
    end
    if node["clamav"]["freshclam"]["enabled"]
      notifies :restart,
        "service[#{node["clamav"]["freshclam"]["service"]}]"
    end
  end
end

template "/etc/init.d/#{node["clamav"]["clamd"]["service"]}" do
  source "clamd.init.rhel.erb"
  mode "0755"
  action :create
  variables(
    :clamd_conf => "#{node["clamav"]["conf_dir"]}/clamd.conf",
    :clamd_pid => node["clamav"]["clamd"]["pid_file"],
    :clamd_bin_dir => "/usr/sbin"
  )
end

template "/etc/init.d/#{node["clamav"]["freshclam"]["service"]}" do
  source "freshclam.init.rhel.erb"
  mode "0755"
  action :create
  variables(
    :freshclam_conf => "#{node["clamav"]["conf_dir"]}/freshclam.conf",
    :freshclam_pid => node["clamav"]["freshclam"]["pid_file"],
    :freshclam_bin_dir => "/usr/bin"
  )
end

user "clam" do
  action :remove
  not_if {node["clamav"]["user"] == "clam"}
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
