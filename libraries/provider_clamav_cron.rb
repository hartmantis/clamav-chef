# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_cron
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
    # A Chef provider for the ClamAV scan cron jobs.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavCron < Provider::LWRPBase
      provides :clamav_cron if defined?(provides)

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
