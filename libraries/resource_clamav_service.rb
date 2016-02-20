# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: resource_clamav_service
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
    # A Chef resource for managing the ClamAV services.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavService < Resource::LWRPBase
      self.resource_name = :clamav_service
      actions Chef::Resource::Service.new('_', nil).allowed_actions
      default_action :nothing

      #
      # The name must be one of the recognized services: 'clamd' or 'freshclam'
      #
      attribute :name,
                kind_of: String,
                required: true,
                equal_to: %w(clamd freshclam)
    end
  end
end
