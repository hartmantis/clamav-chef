ClamAV Cookbook CHANGELOG
=========================

v1.3.1 (2017-02-02)
-------------------
* Open dependencies to allow newer cookbooks to be pulled in
* Upodated rubocop settings and fixed any robocop errors
* Fixed all Foodcritic issues
* Fixed all spec tests that were failing
* Added Ubunto v14 and v16 to spec tests

v1.3.0 (2016-02-05)
-------------------
* Remove the additional Ubuntu repo; it was shut down 2016/01/30
* Run Freshclam any time the virus DB does not exist
* Add an attribute that can be overridden to skip the initial Freshclam run

v1.2.0 (2015-05-07)
-------------------
* Add support for RHEL7
* Add an attribute to control disabling/enabling of the Freshclam cron job
  RHEL installs and disables by default

v1.1.0 (2015-01-27)
-------------------
* In Amazon, use their packages instead of EPEL's
* Remove deprecated `ClamukoScanOnAccess` option

v1.0.2 (2014-02-21)
-------------------
* Remove .DS_Store file accidentally uploaded to community site

v1.0.0 (2014-01-31)
-------------------
* Update to the latest supporting Gems
* Update everything to Rubocop's style guidelines
* Implement ChefSpec v3 unit tests
* Implement full suite of Test Kitchen integration and acceptance tests
* Add support for simple and full scheduled filesystem scans


v0.4.1 (2013-12-13)
-------------------
* Bump dependency cookbook versions

v0.4.0 (2013-03-29)
-------------------
* Default package versions to nil for now to make life easier
* Loosen the cookbook dependencies a little

v0.2.0 (2013-01-16)
-------------------
* Initial release
