# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_service_freshclam_debian
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
require_relative 'provider_clamav_service_freshclam'

class Chef
  class Provider
    class ClamavServiceFreshclam < Provider::LWRPBase
      # A ClamAV freshclam service provider for Ubuntu/Debian.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Debian < ClamavServiceFreshclam
        if defined?(provides)
          provides :clamav_service_freshclam, platform_family: 'debian'
        end

        private

        #
        # (see Chef::Provider::ClamavServiceFreshclam#service_name)
        #
        def service_name
          'clamav-freshclam'
        end
      end
    end
  end
end
