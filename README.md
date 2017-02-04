clamav Cookbook
===============
[![Cookbook Version](http://img.shields.io/cookbook/v/clamav.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/RoboticCheese/clamav-chef.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/RoboticCheese/clamav-chef.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/RoboticCheese/clamav-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/clamav
[travis]: http://travis-ci.org/RoboticCheese/clamav-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/clamav-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/clamav-chef

A cookbook for installing and configuring ClamAV.

Requirements
============

This cookbook requires a RHEL/CentOS/Scientific, Debian/Ubuntu, or compatible
OS.

As of v2.0, it requires Chef 12.5+ or Chef 12.x and the
[compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
cookbook.

Usage
=====
Either add the default recipe to your run list, or use the included custom
resources in a recipe of your own.

Recipes
=======

***default***

Performs an attribute-driven (see below) installation and configuration of
ClamAV.

Attributes
==========

***default***

A recipe-based install offers several attributes that can be overridden and
passed into the various resources.

You can choose to install a specific version of ClamAV instead of the latest.

    default['clamav']['version'] = nil

The development libraries can be installed as well, but are not by default.

    default['clamav']['dev'] = false

A configuration hash can be provided for the `clamd.conf` and `freshclam.conf`
that will be generated.

    default['clamav']['clamd']['config'] = nil
    default['clamav']['freshclam']['config'] = nil

Configuration attributes are set with ClamAV property names in camel-case
format, for example:

    default['clamav"]['clamd']['log_file'] = '/var/log/clamav/clamd.log'
    default['clamav']['clamd']['scan_p_e'] = false

See the ClamAV [documentation](http://www.clamav.net/doc/latest/html/) for
other valid settings.

The two ClamAV daemons are disabled by default.

    default['clamav']['clamd']['enabled'] = false
    default['clamav']['freshclam']['enabled'] = false

Resources
=========

***clamav***

A parent resource that wraps both installation and configuration.

Syntax:

    clamav 'default' do
      enable_clamd false
      enable_freshclam false
      clamd_config {}
      freshclam_config {}
      version '0.9.8'
      dev true
      action :create
    end

Actions:

| Action    | Description                  |
|-----------|------------------------------|
| `:create` | Install and configure ClamAV |
| `:remove` | Uninstall ClamAV             |

Properties:

| Property         | Default   | Description                             |
|------------------|-----------|-----------------------------------------|
| enable_clamd     | `false`   | Whether to enable the clamd daemon      |
| enable_freshclam | `false`   | Whether to enable the freshclam daemon  |
| clamd_config     | `{}`      | A camel-cased clamd.conf config         |
| freshclam_config | `{}`      | A camel-cased freshclam.conf config     |
| version          | `nil`     | A specific version of ClamAV to install |
| dev              | `false`   | Whether to install the dev libraries    |
| action           | `:create` | Action(s) to perform                    |

***clamav_app***

A resource for managing installation of the ClamAV packages.

Syntax:

    clamav_app 'default' do
      version '0.9.8'
      dev true
      action :install
    end

Actions:

| Action     | Description                   |
|------------|-------------------------------|
| `:install` | Install the ClamAV packages   |
| `:upgrade` | Upgrade the ClamAV packages   |
| `:remove`  | Uninstall the ClamAV packages |

Properties:

| Property         | Default    | Description                             |
|------------------|------------|-----------------------------------------|
| version          | `nil`      | A specific version of ClamAV to install |
| dev              | `false`    | Whether to install the dev libraries    |
| action           | `:install` | Action(s) to perform                    |

***clamav_config***

A resource for managing the clamd.conf and freshclam.conf files.

Syntax:

    clamav_config 'clamd' do
      path '/etc/clamav/clamd.conf'
      config {}
      action :create
    end

Actions:

| Action    | Description            |
|-----------|------------------------|
| `:create` | Render the config file |
| `:remove` | Delete the config file |

Properties:

| Property | Default   | Description                             |
|----------|-----------|-----------------------------------------|
| path     | nil       | A custom path to store the file at |
| config   | `{}`      | A camel-cased clamd.conf config         |
| action   | `:create` | Action(s) to perform                    |

***clamav_service***

A resource for managing the clamd and freshclam daemons.

Syntax:

    clamav_service 'clamd' do
      action %i(enable start)
    end

Actions:

| Action     | Description                          |
|------------|--------------------------------------|
| `:enable`  | Set the service to start on boot     |
| `:disable` | Set the service to not start on boot |
| `:start`   | Start the service                    |
| `:stop`    | Stop the service                     |
| `:restart` | Restart the service                  |

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2012-2017, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
