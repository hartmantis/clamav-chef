# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: resource_clamav
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A parent Chef resource that wraps the others up.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Clamav < Resource::LWRPBase
      self.resource_name = :clamav
      actions :create, :remove

      #
      # Attribute to control whether to enable the clamd service.
      #
      attribute :enable_clamd, kind_of: [TrueClass, FalseClass], default: false

      #
      # Attribute to control whether to enable the freshclam service.
      #
      attribute :enable_freshclam,
                kind_of: [TrueClass, FalseClass],
                default: false

      #
      # Attribute for a config hash to pass on to the clamd config.
      #
      attribute :clamd_config, kind_of: Hash, default: {}

      #
      # Attribute for a config hash to pass on to the freshclam config.
      #
      attribute :freshclam_config, kind_of: Hash, default: {}

      #
      # Optionally install a specific version of the ClamAV packages.
      #
      attribute :version, kind_of: [NilClass, String], default: nil

      #
      # Optionally install the dev in addition to base packages.
      #
      attribute :dev,
                kind_of: [TrueClass, FalseClass],
                default: false
    end
  end
end
