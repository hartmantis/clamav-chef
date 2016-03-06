# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: provider_clamav_config
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
require_relative 'helpers_config'
require_relative 'helpers_defaults'

class Chef
  class Provider
    # A Chef provider for ClamAV config files.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavConfig < Provider::LWRPBase
      include ClamavCookbook::Helpers::Defaults

      use_inline_resources

      provides :clamav_config, platform_family: 'debian' if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Build a config file out of the provided hash and write it out to the
      # proper path.
      #
      action :create do
        directory ::File.dirname(path) do
          owner clamav_user
          group clamav_group
          recursive true
        end
        file path do
          owner clamav_user
          group clamav_group
          content ClamavCookbook::Helpers::Config.new(new_resource.config).to_s
        end
      end

      #
      # Delete the config file.
      #
      action :delete do
        file path do
          action :delete
        end
        directory ::File.dirname(path) do
          action :delete
          only_if { Dir.entries(::File.dirname(path)) == %w(. ..) }
        end
      end

      private

      #
      # Return either the user-provided config file path, or the default one
      # for this platform + (clamd || freshclam) service.
      #
      # @return [String] a file path
      # 
      def path
        new_resource.path || ::File.join(clamav_conf_dir,
                                         "#{new_resource.name}.conf")
      end
    end
  end
end
