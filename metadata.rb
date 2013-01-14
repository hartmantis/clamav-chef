name              "clamav"
maintainer        "Jonathan Hartman"
maintainer_email  "j@p4nt5.com"
license           "Apache v2.0"
description       "Installs/configures clamav"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.2"

depends           "logrotate", "= 1.0.2"
depends           "yum", "= 2.1.0"
depends           "apt", "= 1.8.0"

supports          "ubuntu"
supports          "debian"
supports          "redhat", ">= 5.0"
supports          "centos", ">= 5.0"
supports          "scientific", ">= 5.0"
supports          "amazon", ">= 5.0"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
