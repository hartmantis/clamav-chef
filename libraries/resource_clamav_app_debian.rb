# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: resource_clamav_app_debian
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

require_relative 'resource_clamav_app'

class Chef
  class Resource
    # A Debian implemenation of the ClamAV app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavAppDebian < ClamavApp
      provides :clamav_app, platform_family: 'debian'

      class << self
        {
          base_packages: %w(clamav clamav-daemon clamav-freshclam),
          dev_packages: %w(libclamav-dev)
        }.each do |k, v|
          define_method(k) { v }
        end
      end
    end
  end
end
