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

A cookbook for installing and configuring ClamAV. Components to be installed/enabled
are accessible as attributes.

Requirements
============
* A RHEL/CentOS/Scientific, Debian/Ubuntu, or compatible OS

Attributes
==========
Pretty much everything offered as options for ClamAV is configurable. Some
attributes that one might commonly want to override:

    default["clamav"]["clamd"]["enabled"] = false
    default["clamav"]["freshclam"]["enabled"] = false

Whether or not the ClamAV daemons should be running

    default["clamav"]["version"] = "0.97.6<VARIES_BY_OS>"

The version of the ClamAV packages to install

    default["clamav"]["dev_package"] = false

Whether to install the appropriate ClamAV development package

    default["clamav"]["clamd"]["log_file"] = "/var/log/clamav/clamd.log"
    default["clamav"]["clamd"]["logrotate_frequency"] = "daily"
    default["clamav"]["clamd"]["logrotate_rotations"] = 7 
    default["clamav"]["clamd"]["log_file_unlock"] = "no"
    default["clamav"]["clamd"]["log_file_max_size"] = "1M"
    default["clamav"]["clamd"]["log_time"] = "no"
    default["clamav"]["clamd"]["log_clean"] = "no"
    default["clamav"]["clamd"]["log_syslog"] = "no"
    default["clamav"]["clamd"]["log_facility"] = nil 
    default["clamav"]["clamd"]["log_verbose"] = "no"
    default["clamav"]["freshclam"]["update_log_file"] = "/var/log/clamav/freshclam.log"
    default["clamav"]["freshclam"]["logrotate_frequency"] = "daily"
    default["clamav"]["freshclam"]["logrotate_rotations"] = 7
    default["clamav"]["freshclam"]["log_file_max_size"] = "1M"
    default["clamav"]["freshclam"]["log_time"] = "no"
    default["clamav"]["freshclam"]["log_verbose"] = "no"
    default["clamav"]["freshclam"]["log_syslog"] = "no"
    default["clamav"]["freshclam"]["log_facility"] = nil 

Log file/syslog facility logging options

    default['clamav']['scan']['script']['enable'] = false
    default['clamav']['scan']['minimal']['enable'] = false
    default['clamav']['scan']['full']['enable'] = false

Optionally enable a daily minimum virus scan and/or a weekly virus scan of the
full filesystem.

ClamAV has many other options. See the attribute files and ClamAV
[documentation](http://www.clamav.net/doc/latest/html/) for details.

Usage
=====
Nothing special. Override the default attributes as you see fit and go to town!

Development
=====
Feel free to fork this project and submit any changes via pull request.

Testing
=====
This cookbook implements several suites of syntax, style, unit, integration and
acceptance tests, utilizing a number of tools:

* [Vagrant](http://vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/) for creating virtual environments
* [Berkshelf](http://berkshelf.com/) for retrieving cookbook dependencies
* [Rubocop](https://github.com/bbatsov/rubocop) for Ruby lint tests
* [FoodCritic](http://www.foodcritic.io) for Chef lint tests
* [ChefSpec](https://github.com/sethvargo/chefspec) for the cookbook unit tests
* [Serverspec](http://serverspec.org) for post-converge integration tests
* [Cucumber](http://cukes.info/) for high-level acceptance tests
* [Test Kitchen](http://kitchen.ci) to tie all the tests together


To run the entire suite of tests, simple:

    rake

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add appropriate unit and/or integration tests
4. Ensure all tests pass (`rake`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2012-2016, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
