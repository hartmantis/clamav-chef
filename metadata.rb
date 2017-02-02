# Encoding: UTF-8

name              'clamav'
maintainer        'Jonathan Hartman'
maintainer_email  'j@p4nt5.com'
license           'Apache v2.0'
description       'Installs/configures ClamAV'
long_description  'Installs/configures ClamAV'
source_url        'https://github.com/RoboticCheese/clamav-chef/issues'
issues_url        'https://github.com/RoboticCheese/clamav-chef/issues'
version           '1.3.1'

depends           'apt'
depends           'logrotate', '>= 1.0'
depends           'yum', '>= 3.0'
depends           'yum-epel', '>= 0.2'

supports          'ubuntu'
supports          'debian'
supports          'redhat', '>= 5.0'
supports          'centos', '>= 5.0'
supports          'scientific', '>= 5.0'
supports          'amazon', '>= 5.0'
