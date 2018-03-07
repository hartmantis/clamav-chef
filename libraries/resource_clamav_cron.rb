# encoding: utf-8
# frozen_string_literal: true
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

require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for creating a ClamAV scan cron job.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavCron < Resource
      provides :clamav_cron

      default_action :create

      #
      # Properties for the underlying cron job definition.
      #
      %i(minute hour day month weekday).each do |p|
        property p, [Integer, String], required: true
      end

      #
      # A filesystem path or array of paths to scan.
      #
      property :paths, [Array, String], default: %w(/)

      #
      # Create the cron job.
      #
      action :create do
        cron_d "clamav-#{new_resource.name}" do
          minute new_resource.minute
          hour new_resource.hour
          day new_resource.day
          month new_resource.month
          weekday new_resource.weekday
          command "clamscan #{new_resource.paths.join(' ')}"
        end
      end

      #
      # Delete the cron job.
      #
      action :delete do
        cron_d "clamav-#{new_resource.name}" do
          action :delete
        end
      end
    end
  end
end
