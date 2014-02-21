# -*- encoding: utf-8 -*-

name              'clamav'
maintainer        'Jonathan Hartman'
maintainer_email  'j@p4nt5.com'
license           'Apache v2.0'
description       'Installs/configures ClamAV'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.0.3'

depends           'logrotate', '~> 1.0'
depends           'yum', '~> 3.0'
depends           'yum-epel', '~> 0.2'
depends           'apt', '~> 2.1'
depends           'cron', '~> 1.2'

supports          'ubuntu'
supports          'debian'
supports          'redhat', '>= 5.0'
supports          'centos', '>= 5.0'
supports          'scientific', '>= 5.0'
supports          'amazon', '>= 5.0'

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
