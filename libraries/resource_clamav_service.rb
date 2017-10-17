# encoding: utf-8
# frozen_string_literal: true
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

require 'chef/resource'
require_relative 'helpers_defaults'

class Chef
  class Resource
    # A Chef resource for managing the ClamAV services.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavService < Resource
      include ClamavCookbook::Helpers::Defaults

      provides :clamav_service

      #
      # The service must be one of the recognized services: 'clamd' or
      # 'freshclam'.
      #
      property :service_name,
               String,
               name_property: true,
               equal_to: %w(clamd freshclam)

      def update_definitions_file
        definitions_file = ::File.join(clamav_data_dir, 'main.cvd')

        if !::File.exist?(definitions_file) ||
           (Time.now - 24*60*60) > ::File.stat(definitions_file).mtime
          execute 'Ensure virus definitions exist so clamd can start' do
            command 'freshclam'
          end
        end
      end

      #
      # Iterate over every action available for a regular service resource and
      # pass the declared action on to one.
      #
      Resource::Service.allowed_actions.each do |a|
        action a do
          if a == :start && new_resource.service_name == 'clamd'
            update_definitions_file
          end
          service send("#{new_resource.service_name}_service_name") do
            supports(status: true, restart: true)
            action a
          end
        end
      end

      default_action :nothing
    end
  end
end
