# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: clamav
# Library:: resource_clamav_service
#
# Copyright 2012-2017, Jonathan Hartman
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
    # A Chef resource for managing the ClamAV services.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavService < Resource
      #
      # The service must be one of the recognized services: 'clamd' or
      # 'freshclam'.
      #
      property :service_name,
               String,
               name_property: true,
               equal_to: %w[clamd freshclam]

      #
      # The 'clamd' or 'freshclam' service then gets translated into whatever
      # name the specific platform's init system uses.
      #
      property :platform_service_name,
               String,
               required: true,
               default: lazy { |r|
                 r.class::DEFAULTS["#{r.service_name}_service_name".to_sym]
               }

      #
      # Whether to wait for Freshclam to do its initial update when starting it
      # for the first time. This can be disabled, but doing so will result in
      # errors if trying to start the clamd service before freshclam has put
      # any virus definitions in place.
      #
      property :wait_for_freshclam,
               [TrueClass, FalseClass],
               default: lazy { |r|
                 r.service_name == 'freshclam' && \
                   r.action.include?(:start) && \
                   !::File.exist?('/var/lib/clamav/main.cvd')
               }

      #
      # Iterate over every action available for a regular service resource and
      # pass the declared action on to one.
      #
      Resource::Service.allowed_actions.each do |a|
        action a  do
          service new_resource.platform_service_name do
            supports(status: true, restart: true)
            action a
          end

          if new_resource.wait_for_freshclam
            ruby_block 'Wait for freshclam to do its initial update' do
              block do
                raise unless ::File.exist?('/var/lib/clamav/main.cvd')
                raise if Dir.glob('/var/lib/clamav/daily.c[vl]d').empty?
                raise unless ::File.exist?('/var/lib/clamav/bytecode.cvd')
              end
              retries 180
              retry_delay 10
            end
          end
        end
      end

      default_action :nothing
    end
  end
end
