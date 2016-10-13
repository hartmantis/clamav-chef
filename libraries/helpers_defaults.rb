# encoding: utf-8
# frozen_string_literal: true
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
        when 'rhel'
          if node['platform_version'].to_i >= 7
            'clamd@server.service'
          else
            'clamd'
          end
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

      #
      # The bare minimum freshclam.conf required for it to function.
      #
      # @return [Hash] a barebones freshclam config
      #
      def freshclam_config
        { database_mirror: %w(db.local.clamav.net database.clamav.net) }
      end

      #
      # The bare minimum clamd.conf required for it to function.
      #
      # @return [Hash] a barebones clamd config
      #
      def clamd_config
        { local_socket: '/var/run/clamav/clamd.sock' }
      end

      #
      # The directory containing ClamAV's virus definition files.
      #
      # @return [String] the data directory
      #
      def clamav_data_dir
        case node['platform_family']
        when 'debian', 'rhel'
          '/var/lib/clamav'
        end
      end

      #
      # The directory containing the platform's ClamAV config files.
      #
      # @return [String] the config directory
      #
      def clamav_conf_dir
        case node['platform_family']
        when 'debian', 'rhel'
          '/etc/clamav'
        end
      end

      #
      # The platform's ClamAV user.
      #
      # @return [String] the user
      #
      def clamav_user
        case node['platform_family']
        when 'debian'
          'clamav'
        when 'rhel'
          if node['platform_version'].to_i >= 7
            'root'
          else
            'clam'
          end
        end
      end

      #
      # The platform's ClamAV group.
      #
      # @return [String] the group
      #
      def clamav_group
        case node['platform_family']
        when 'debian'
          'clamav'
        when 'rhen'
          if node['platform_version'].to_i >= 7
            'root'
          else
            'clam'
          end
        end
      end

      #
      # The list of packages that constitute a "base" install.
      #
      # @return [Array<String>] a list of base packages
      #
      def base_packages
        case node['platform_family']
        when 'debian'
          %w(clamav clamav-daemon clamav-freshclam)
        when 'rhel'
          if node['platform_version'].to_i >= 7
            %w(clamav-server clamav clamav-update clamav-server-systemd clamav-scanner clamav-scanner-systemd)
          else
            %w(clamav clamav-db clamd clamav-server-sysvinit clamav-scanner)
          end
        end
      end

      #
      # The list of packages that constitute the development libraries.
      #
      # @return [Array<String>] a list of dev packages
      #
      def dev_packages
        case node['platform_family']
        when 'debian'
          %w(libclamav-dev)
        when 'rhel'
          %w(clamav-devel)
        end
      end
    end
  end
end
