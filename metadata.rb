# encoding: utf-8
# frozen_string_literal: true

name 'clamav'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'Apache v2.0'
description 'Installs/configures ClamAV'
long_description 'Installs/configures ClamAV'
version '1.3.1'
chef_version '>= 12'

source_url 'https://github.com/roboticcheese/clamav-chef'
issues_url 'https://github.com/roboticcheese/clamav-chef/issues'
depends           'logrotate', '~> 1.0'
depends           'yum', '~> 3.0'
depends           'yum-epel', '~> 0.2'
depends           'apt', '~> 2.1'
depends           'poise-service'
# Note that a breaking bug was introduced in 1.3.10 and fixed in 1.3.12, but
# we really don't want a ">=" cookbook dep situation here
depends           'cron', '~> 1.2'

supports 'ubuntu'
supports 'debian'
