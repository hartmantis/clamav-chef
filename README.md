[![Build Status](https://travis-ci.org/RoboticCheese/clamav.png?branch=master)](https://travis-ci.org/RoboticCheese/clamav)

Description
===========
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
As a first project to implement cookbook tests, I probably went a bit
overboard, but this cookbook implements several sets of tests using a number
of tools.

* [Vagrant](http://vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) for creating virtual environments
* [Berkshelf](http://berkshelf.com/) for retrieving cookbook dependencies
* [FoodCritic](http://acrmp.github.com/foodcritic/) for lint tests
* [ChefSpec](https://github.com/acrmp/chefspec/) for the cookbook tests
* [Minitest Chef Handler](https://github.com/calavera/minitest-chef-handler) for the full-on Chef run tests
* [Cucumber](http://cukes.info/) for high-level behavior tests
* [Test Kitchen](https://github.com/opscode/test-kitchen) to tie all the tests together

To run the Foodcritic tests only, run:

    foodcritic

To run the ChefSpec tests:

    rspec

To start up a development environment for basic Chef run verification:

    vagrant up

To do a full-on run of all tests on every supported platform:

    kitchen test

To Do
=====
* Use Fauxhai for some of the spec tests
