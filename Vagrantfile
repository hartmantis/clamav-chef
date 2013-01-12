# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["BERKSHELF_PATH"] = File.expand_path(".berkshelf")
require "berkshelf/vagrant"

box_prefix = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes"

Vagrant::Config.run do |config|
  config.vm.define :centos6 do |centos|
    centos.vm.box = "opscode-centos-6.3"
    centos.vm.box_url = "#{box_prefix}/opscode-centos-6.3.box"
  end

  config.vm.define :centos5 do |centos|
    centos.vm.box = "opscode-centos-5.8"
    centos.vm.box_url = "#{box_prefix}/opscode-centos-5.8.box"
  end

  config.vm.define :ubuntu1204 do |ubuntu|
    ubuntu.vm.box = "opscode-ubuntu-12.04"
    ubuntu.vm.box_url = "#{box_prefix}/opscode-ubuntu-12.04.box"
  end

  config.vm.define :ubuntu1004 do |ubuntu|
    ubuntu.vm.box = "opscode-ubuntu-10.04"
    ubuntu.vm.box_url = "#{box_prefix}/opscode-ubuntu-10.04.box"
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "clamav"
    chef.json = {
      :clamav => {
        :clamd => {
          :enabled => true
        },
        :freshclam => {
          :enabled => true
        }
      }
    }
  end

end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
