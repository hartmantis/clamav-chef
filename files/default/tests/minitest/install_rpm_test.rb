#
# Cookbook Name:: clamav
# Spec:: install_rpm
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

require "minitest/spec"
require File.expand_path("../support/helpers.rb", __FILE__)

describe_recipe "clamav::install_rpm" do
  include Helpers::ClamAV

  it "should install the EPEL repo" do
    file("/etc/yum.repos.d/epel.repo").must_exist
  end

  it "should install the required packages from EPEL" do
    %w{clamav clamav-db clamd}.each do |p|
      package(p).must_be_installed
      if node["clamav"]["version"]
        package(p).must_be_installed
        package(p).must_have(:version, node["clamav"]["version"])
      end
      %x{rpm -q --qf '%{VENDOR}' #{p}}.must_equal "Fedora Project"
    end
  end

  it "should install the optional dev package if enabled" do
    p = "clamav-devel"
    if node["clamav"]["dev_package"]
      package(p).must_be_installed
      if node["clamav"]["version"]
        package(p).must_have(:version, node["clamav"]["version"])
      end
    end
  end

  it "should create the the init scripts" do
    inits = %W{
      /etc/init.d/#{node["clamav"]["clamd"]["service"]}
      /etc/init.d/#{node["clamav"]["freshclam"]["service"]}
    }
    inits.each do |f|
      file(f).must_exist
      file(f).must_have(:mode, "755")
      file(f).must_have(:owner, "root").and(:group, "root")
    end
  end

  it "should delete the RPM's user if it will be unused" do
    node["clamav"]["user"] != "clam" and user("clam").wont_exist
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
