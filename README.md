[![Build Status](https://travis-ci.org/RoboticCheese/clamav-chef.png?branch=master)](https://travis-ci.org/RoboticCheese/clamav-chef)

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
