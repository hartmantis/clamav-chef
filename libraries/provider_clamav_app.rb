# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_app
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
    # A Chef provider for the ClamAV application packages.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavApp < Provider::LWRPBase
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
      # Install the ClamAV packages.
      #
      action :install do
        packages(:install)
      end

      #
      # Upgrade the ClamAV packages.
      #
      action :upgrade do
        packages(:upgrade)
      end

      #
      # Remove the ClamAV packages
      #
      action :remove do
        packages(:remove)
      end

      private

      #
      # Loop through each package resource and perform the same action on each.
      #
      # @param [Symbol] action action to perform
      #
      def packages(action)
        plist = base_packages
        plist += dev_packages if new_resource.dev || action == :remove
        plist.each do |p|
          package p do
            version new_resource.version
            action action
          end
        end
      end

      #
      # Return the array of base packages to perform actions on.
      #
      # @return [Array] a package list
      #
      # @raise [NotImplementedError] if not implemented for the platform
      #
      def base_packages
        raise(NotImplementedError,
              "#base_packages must be implemented for #{self.class} provider")
      end

      #
      # Return the array of dev packages to perform actions on.
      #
      # @return [Array] a package list
      #
      # @raise [NotImplementedError] if not implemented for the platform
      #
      def dev_packages
        raise(NotImplementedError,
              "#dev_packages must be implemented for #{self.class} provider")
      end
    end
  end
end
