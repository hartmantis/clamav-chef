#
# Cookbook Name:: clamav
# Attributes:: default
#
# Copyright 2012-2013, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Shared and OS-Specific Options
base_ver = "0.97.6"
case node["platform_family"]
when "rhel"
  major_ver = node["platform_version"].split(".")[0]
  default["clamav"]["version"] = "#{base_ver}-1.el#{major_ver}"
  default["clamav"]["conf_dir"] = "/etc"
when "debian"
  if node["platform"] == "ubuntu"
    case node["platform_version"]
    when "10.04"
      default["clamav"]["version"] = "#{base_ver}+dfsg-1ubuntu0.11.04.1~" +
        "10.04.1~ppa1"
    when "12.04"
      default["clamav"]["version"] = nil
    else
      default["clamav"]["version"] = "#{base_ver}+dfsg-1ubuntu0." +
        "#{node["platform_version"]}.1"
    end
  else
    default["clamav"]["version"] = base_ver
  end
  default["clamav"]["conf_dir"] = "/etc/clamav"
end
default["clamav"]["dev_package"] = false
default["clamav"]["database_directory"] = "/var/lib/clamav"
default["clamav"]["user"] = "clamav"
default["clamav"]["group"] = "clamav"
default["clamav"]["allow_supplementary_groups"] = "no"
default["clamav"]["bytecode"] = "yes"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
