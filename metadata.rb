# Encoding: UTF-8

name              'clamav'
maintainer        'Jonathan Hartman'
maintainer_email  'j@p4nt5.com'
license           'Apache v2.0'
description       'Installs/configures ClamAV'
long_description  'Installs/configures ClamAV'
version           '1.3.1'

depends           'logrotate', '~> 1.0'
depends           'yum', '~> 3.0'
depends           'yum-epel', '~> 0.2'
depends           'cron', '~> 1.2'

supports          'ubuntu'
supports          'debian'
supports          'redhat'
supports          'centos'
supports          'scientific'
supports          'amazon'
