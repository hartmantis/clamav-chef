# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: resource_clamav_update
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
    # A Chef resource for doing a one-time virus definition update. This
    # resource should be useful only in limited circumstances, since one would
    # normally enable the freshclam service and let it do all the updating.
    # This resource will fail to run if freshclam is enabled.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavUpdate < Resource
      provides :clamav_update

      default_action :run

      #
      # Updates can be done via shelling out to freshclam (`:freshclam`, the
      # default), downloading the files from database.clamav.net (`:direct`)
      # or from any `file://` or `http://` remote path that the files exist in.
      #
      property :source,
               [Symbol, String],
               default: :freshclam,
               regex: [/^freshclam$/, %r{^file://}, %r{https?://}],
               coerce: proc { |v|
                 case v.to_sym
                 when :freshclam
                   v.to_sym
                 when :direct
                   'http://database.clamav.net'
                 else
                   v.to_s
                 end
               }

      #
      # Run the desired update operation.
      #
      action :run do
        case new_resource.source
        when :freshclam
          execute 'freshclam'
        else
          %w(main.cvd daily.cvd bytecode.cvd).each do |f|
            remote_file ::File.join('/var/lib/clamav', f) do
              source ::File.join(new_resource.source, f)
            end
          end
        end
      end
    end
  end
end
