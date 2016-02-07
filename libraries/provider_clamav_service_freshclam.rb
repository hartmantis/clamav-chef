# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_service_freshclam
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
require_relative 'resource_clamav_service_freshclam'

class Chef
  class Provider
    # A Chef provider for the ClamAV freshclam service.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavServiceFreshclam < Provider::LWRPBase
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
      # Iterate over each service action and pass it on the the inline service
      # resource.
      #
      Resource::ClamavServiceClamd.new('_', nil).allowed_actions.each do |a|
        action(a) { service(service_name) { action a } }
      end

      private

      #
      # Return the name of the freshclam service for the current platform.
      #
      # @return [String] the name of the service
      #
      # @raise [NotImplementedError] if not implemented for the platform
      #
      def service_name
        raise(NotImplementedError,
              "#service_name must be implemented for #{self.class} provider")
      end
    end
  end
end
