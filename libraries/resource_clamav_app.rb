# Encoding: UTF-8
#
# Cookbook Name:: clamav
# Library:: resource_clamav_app
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A Chef resource for groups of ClamAV packages.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavApp < Resource::LWRPBase
      self.resource_name = :clamav_app
      actions :install, :remove, :upgrade
      default_action :install

      #
      # Optionally install a specific version of the ClamAV packages. This
      # assumes that packages will continue to always all be the same version.
      # Different distros use vastly different version strings in their
      # packages, so type checking is about the only validation we can do.
      #
      attribute :version, kind_of: [NilClass, String], default: nil

      #
      # Optionally install the dev in addition to base packages.
      #
      attribute :dev,
                kind_of: [TrueClass, FalseClass],
                default: false
    end
  end
end
