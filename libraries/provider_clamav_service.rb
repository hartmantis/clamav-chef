# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_service
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
require_relative 'helpers_defaults'
require_relative 'resource_clamav_service'

class Chef
  class Provider
    # A Chef provider for managing the ClamAV services.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavService < Provider::LWRPBase
      include ClamavCookbook::Helpers::Defaults

      use_inline_resources

      provides :clamav_service, platform_family: 'debian' if defined?(provides)

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
      Resource::ClamavService.new('clamd', nil).allowed_actions.each do |a|
        action(a) do
          service(send("#{new_resource.name}_service_name")) { action a }
        end
      end
    end
  end
end
