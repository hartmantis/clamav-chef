#
# Cookbook Name:: clamav
# Spec:: logging
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

describe_recipe "clamav::logging" do
  include Helpers::ClamAV

  it "create the log files with proper ownership" do
    files = [
      node["clamav"]["clamd"]["log_file"],
      node["clamav"]["freshclam"]["update_log_file"]
    ].uniq
    files.map {|f| File.dirname(f)}.uniq.each do |d|
      directory(d).must_exist_with(:owner, node["clamav"]["user"]).
        and(:group, node["clamav"]["group"])
    end
    files.each do |f|
      file(f).must_exist_with(:owner, node["clamav"]["user"]).
        and(:group, node["clamav"]["group"])
    end
  end

  it "creates the logrotate configs for those log files" do
    {
      "/etc/logrotate.d/clamav" =>
        node["clamav"]["clamd"]["log_file"],
      "/etc/logrotate.d/freshclam" =>
        node["clamav"]["freshclam"]["update_log_file"]
    }.each do |f, l|
      file(f).must_exist
      file(f).must_include "#{l} {"
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
