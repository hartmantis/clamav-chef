# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: resource_clamav_config
#
# Copyright 2012-2017, Jonathan Hartman
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
    # A Chef resource for ClamAV config files.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavConfig < Resource
      default_action :create

      #
      # The service must be one of the recognized services: 'clamd' or
      # 'freshclam'.
      #
      property :service_name,
               String,
               name_property: true,
               equal_to: %w(clamd freshclam)

      #
      # Allow the user to override the path of the config dir (at their peril).
      #
      property :path,
               String,
               default: lazy { |r| r.class::DEFAULTS[:conf_dir] }
      #
      # The name of the ClamAV user.
      #
      property :user, String, default: lazy { |r| r.class::DEFAULTS[:user] }

      #
      # The name of the ClamAV group.
      #
      property :group, String, default: lazy { |r| r.class::DEFAULTS[:group] }

      #
      # A hash of config values.
      #
      property :config,
               Hash,
               default: lazy { |r|
                 r.class::DEFAULTS["#{r.service_name}_config".to_sym]
               },
               coerce: proc { |val|
                 val.each_with_object({}) { |(k, v), hsh| hsh[k.to_sym] = v }
               }

      #
      # Allow individual properties to be fed in and merged with the config
      # hash, e.g.
      #
      # clamav_config 'clamd' do
      #   max_queue 100
      #   pid_file '/var/run/clamav/clamd.pid'
      # end
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        super
      rescue NoMethodError
        raise if !block.nil? || args.length > 1
        case args.length
        when 1
          config[method_symbol] = args[0]
        when 0
          config[method_symbol] || raise
        end
      end

      #
      # Build a config file out of the provided hash and write it out to the
      # proper path.
      #
      action :create do
        directory new_resource.path do
          owner new_resource.user
          group new_resource.group
          recursive true
        end
        file ::File.join(new_resource.path,
                         "#{new_resource.service_name}.conf") do
          owner new_resource.user
          group new_resource.group
          content ClamavCookbook::Helpers::Config.new(new_resource.config).to_s
        end
      end

      #
      # Delete the config file.
      #
      action :delete do
        file ::File.join(new_resource.path,
                         "#{new_resource.service_name}.conf") do
          action :delete
        end
        directory(new_resource.path) do
          action :delete
        end
      end
    end
  end
end
