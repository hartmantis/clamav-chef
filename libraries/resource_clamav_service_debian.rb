# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: resource_clamav_service_debian
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

require_relative 'resource_clamav_service'

class Chef
  class Resource
    # A Debian implementation of the ClamAV service resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavServiceDebian < ClamavService
      provides :clamav_service, platform_family: 'debian'

      DEFAULTS ||= {
        clamd_service_name: 'clamav-daemon',
        freshclam_service_name: 'clamav-freshclam'
      }
    end
  end
end
