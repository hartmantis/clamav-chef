#
# Cookbook Name:: clamav
# Spec:: freshclam
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

describe_recipe "clamav::freshclam" do
  include Helpers::ClamAV

  it "should create freshclam.conf" do
    f = "#{node["clamav"]["conf_dir"]}/freshclam.conf"
    file(f).must_exust_with(:mode, "0644").
      and(:owner, node["clamav"]["user"]).
      and(:group, node["clamav"]["group"])
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
