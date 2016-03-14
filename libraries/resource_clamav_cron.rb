# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: resource_clamav_cron
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
    # A Chef resource for creating a ClamAV scan cron job.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavCron < Resource::LWRPBase
      self.resource_name = :clamav_cron
      actions :create, :delete
      default_action :create

      #
      # Attributes for the underlying cron job definition.
      #
      [:minute, :hour, :day, :month, :weekday].each do |a|
        attribute a, kind_of: [Fixnum, String], required: true
      end

      #
      # A list of filesystem paths to scan
      #
      attribute :paths, kind_of: [Array, String], default: %w(/)
    end
  end
end
