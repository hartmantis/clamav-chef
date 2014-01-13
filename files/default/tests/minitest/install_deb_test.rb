#
# Cookbook Name:: clamav
# Spec:: install_deb
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

require "minitest/spec"
require File.expand_path("../support/helpers.rb", __FILE__)

describe_recipe "clamav::install_deb" do
  include Helpers::ClamAV

  it "should install the ClamAV APT repo under Ubuntu" do
    if node["platform"] == "ubuntu"
      file("/etc/apt/sources.list.d/clamav-repo.list").must_exist
    end
  end

  it "should install clamav and clamav-daemon" do
    %w{clamav clamav-daemon}.each do |p|
      package(p).must_be_installed
      if node["clamav"]["version"]
        package(p).must_have(:version, node["clamav"]["version"])
      end
    end
  end

  it "should install the optional dev package if enabled" do
    p = "libclamav-dev"
    if node["clamav"]["dev_package"]
      package(p).must_be_installed
      if node["clamav"]["version"]
        package(p).must_have(:version, node["clamav"]["version"])
      end
    end
  end

  it "should delete the default logrotate files" do
    logrots = %w{
      /etc/logrotate.d/clamav-daemon
      /etc/logrotate.d/clamav-freshclam
    }
    logrots.each do |f|
      file(f).wont_exist
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
