# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_app_debian
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

require 'chef/dsl/include_recipe'
require 'chef/provider/lwrp_base'
require_relative 'provider_clamav_app'

class Chef
  class Provider
    class ClamavApp < Provider::LWRPBase
      # A ClamAV app provider for Ubuntu/Debian.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Debian < ClamavApp
        include Chef::DSL::IncludeRecipe

        provides :clamav_app, platform_family: 'debian' if defined?(provides)

        #
        # Ensure the APT cache is up to date before proceeding with package
        # installation.
        #
        # (see Chef::Provider::ClamavApp#action_install)
        #
        action :install do
          include_recipe 'apt'
          super()
        end

        #
        # Ensure the APT cache is up to date before proceeding with package
        # upgrade.
        #
        # (see Chef::Provider::ClamavApp#action_install)
        #
        action :upgrade do
          include_recipe 'apt'
          super()
        end

        #
        # (see ClamavApp#base_packages)
        #
        def base_packages
          %w(clamav clamav-daemon clamav-freshclam)
        end

        #
        # (see ClamavApp#dev_packages
        #
        def dev_packages
          %w(libclamav-dev)
        end
      end
    end
  end
end
