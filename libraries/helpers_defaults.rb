# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: helpers_defaults
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

module ClamavCookbook
  module Helpers
    # A set of helpers for some of the assorted default properties that vary
    # from one platform to another.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module Defaults
      #
      # The name of the ClamAV daemon service.
      #
      # @return [String] the service name
      #
      def clamd_service_name
        case node['platform_family']
        when 'debian'
          'clamav-daemon'
        end
      end

      #
      # The name of the ClamAV freshclam service.
      #
      # @return [String] the service name
      #
      def freshclam_service_name
        case node['platform_family']
        when 'debian'
          'clamav-freshclam'
        end
      end
    end
  end
end
