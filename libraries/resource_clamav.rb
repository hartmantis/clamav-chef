# encoding: utf-8
# frozen_string_literal: true
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

require 'chef/resource'

class Chef
  class Resource
    # A parent Chef resource that wraps the others up.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Clamav < Resource
      provides :clamav

      default_action :create

      #
      # Should we enable the clamd service?
      #
      property :enable_clamd, [TrueClass, FalseClass], default: false

      #
      # Should we enable the freshclam service?
      #
      property :enable_freshclam, [TrueClass, FalseClass], default: false

      #
      # Property for a config hash to pass on to the clamd config.
      #
      property :clamd_config, Hash, default: {}

      #
      # Property for a config hash to pass on to the freshclam config.
      #
      property :freshclam_config, Hash, default: {}

      #
      # Optionally install a specific version of the ClamAV packages.
      #
      property :version, [String, nil], default: nil

      #
      # Optionally install the dev in addition to base packages.
      #
      property :dev, [TrueClass, FalseClass], default: false

      #
      # Install ClamAV, configure it, and enable or disable the services.
      #
      action :create do
        clamav_app new_resource.name do
          version new_resource.version
          dev new_resource.dev
        end
        clamav_config 'clamd' do
          config new_resource.clamd_config
          if new_resource.enable_clamd
            notifies :restart, 'clamav_service[clamd]'
          end
        end
        clamav_config 'freshclam' do
          config new_resource.freshclam_config
          if new_resource.enable_freshclam
            notifies :restart, 'clamav_service[freshclam]'
          end
        end
        clamav_service 'clamd' do
          action(if new_resource.enable_clamd
                   %i(enable start)
                 else
                   %i(stop disable)
                 end)
        end
        clamav_service 'freshclam' do
          action(if new_resource.enable_freshclam
                   %i(enable start)
                 else
                   %i(stop disable)
                 end)
        end
      end

      #
      # Disable both ClamAV services, delete the configurations, and remove the
      # packages.
      #
      action :remove do
        clamav_service('clamd') { action %i(stop disable) }
        clamav_service('freshclam') { action %i(stop disable) }
        clamav_config('clamd') { action :delete }
        clamav_config('freshclam') { action :delete }
        clamav_app(new_resource.name) { action :remove }
      end
    end
  end
end
