# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: resource_clamav_config
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
    # A Chef resource for ClamAV config files.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavConfig < Resource::LWRPBase
      self.resource_name = :clamav_config
      actions :create, :delete
      default_action :create

      #
      # The name must be one of the recognized services: 'clamd' or 'freshclam'
      #
      attribute :name,
                kind_of: String,
                required: true,
                equal_to: %w(clamd freshclam)

      #
      # Allow the user to override the path of the config file (at their peril).
      #
      attribute :path, kind_of: [String, NilClass], default: nil

      #
      # A hash of config values
      #
      attribute :config, kind_of: [Hash, NilClass], default: nil
    end
  end
end
