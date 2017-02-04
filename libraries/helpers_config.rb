# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: helpers_config
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

require 'chef/mixin/convert_to_class_name'

module ClamavCookbook
  module Helpers
    # A helper class for building ClamAV config files out of Chef attributes.
    # ClamAV options all camel-cased with initialisms fully capitalized, e.g.:
    #
    #   LocalSocket /var/run/clamav/clamd.ctl
    #   FixStaleSocket true
    #   ScanPE true
    #   ScanSWF true
    #   PidFile /var/run/clamav/clamd.pid
    #
    # For options that can have an array of values, they are listed multiple
    # times, e.g.:
    #
    #   DatabaseMirror db.local.clamav.net
    #   DatabaseMirror database.clamv.net
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Config
      include Chef::Mixin::ConvertToClassName

      class << self
        include Chef::Mixin::ConvertToClassName

        #
        # Read in an already-existing ClamAV config file and generate a Config
        # object based on it.
        #
        # @param path [String] a path to the config file
        #
        # @return [ClamavCookbook::Helpers::Config] a new config object
        #
        def from_file(path)
          from_s(File.open(path).read)
        end

        #
        # Parse an input string containing a ClamAV config and generate a
        # Config object based on it.
        #
        # @param conf [String] a config string
        #
        # @return [ClamavCookbook::Helpers::Config] a new config object
        #
        def from_s(conf)
          parsed = conf.lines.map(&:strip).each_with_object({}) do |line, hsh|
            k, v = parse_line(line)
            hsh[k] = hsh[k] ? Array(hsh[k]) + Array(v) : v
          end
          Config.new(parsed)
        end

        #
        # Parse a single line of a config, converting the strings "true" and
        # "false" into their boolean equivalents.
        #
        # @param line [String] a line from a ClamAV config
        #
        # @return [Array] a key and value
        #
        def parse_line(line)
          k, v = line.split
          k = convert_to_snake_case(k).to_sym
          v = true if v == 'true'
          v = false if v == 'false'
          [k, v]
        end
      end

      #
      # Initialize a new config object based on a hash or mash, most likely
      # from Chef attributes, with keys in snake-case format.
      #
      # @param config [Hash] a snake-case ClamAV config
      # @param config [Mash] a snake-case ClamAV config
      #
      # @return [ClamavCookbook::Helpers::Config] a new config object
      #
      def initialize(config = {})
        @config = config || {}
      end

      #
      # Render the config object as a string suitable for writing out to a
      # ClamAV config file.
      #
      # @return [String] a ClamAV config file body
      #
      def to_s
        header = ['##############################################',
                  '# This file generated automatically by Chef. #',
                  '# Any local changes will be overwritten.     #',
                  '##############################################']
        body = @config.sort.to_h.map do |k, vs|
          Array(vs).map do |v|
            "#{convert_to_class_name(k.to_s)} #{v}"
          end
        end.flatten
        (header + body).join("\n")
      end
    end
  end
end
