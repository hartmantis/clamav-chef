# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav
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

require 'chef/provider/lwrp_base'

class Chef
  class Provider
    # A Chef provider for the ClamAV parent resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Clamav < Provider::LWRPBase
      provides :clamav if defined?(provides)

      use_inline_resources

      #
      # WhyRun is supported by this provider
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Install ClamAV, configure it, and enable or disable the services.
      #
      action :create do
        clamav_app new_resource.name do
          version new_resource.version
          dev new_resource.dev
        end
        clamav_config('clamd') do
          config new_resource.clamd_config
          if new_resource.enable_clamd
            notifies :restart, 'clamav_service[clamd]'
          end
        end
        clamav_config('freshclam') do
          config new_resource.freshclam_config
          if new_resource.enable_freshclam
            notifies :restart, 'clamav_service[freshclam]'
          end
        end
        clamav_service 'clamd' do
          action new_resource.enable_clamd ? [:enable, :start] : \
            [:stop, :disable]
        end
        clamav_service 'freshclam' do
          action new_resource.enable_freshclam ? [:enable, :start] : \
            [:stop, :disable]
        end
      end

      #
      # Disable both ClamAV services, delete the configurations, and remove the
      # packages.
      #
      action :remove do
        clamav_service('clamd') { action [:stop, :disable] }
        clamav_service('freshclam') { action [:stop, :disable] }
        clamav_config('clamd') { action :delete }
        clamav_config('freshclam') { action :delete }
        clamav_app(new_resource.name) { action :remove }
      end
    end
  end
end
