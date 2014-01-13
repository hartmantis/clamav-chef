#
# Cookbook Name:: clamav
# Spec:: users
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

describe_recipe "clamav::users" do
  include Helpers::ClamAV

  it "should create the needed user and group" do
    user(node["clamav"]["user"]).must_exist
    group(node["clamav"]["group"]).must_exist
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
