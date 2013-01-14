require "chefspec"

describe "clamav::install_deb" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::install_deb"
    @pkgs = %w{clamav clamav-daemon}
    @svcs = %w{clamav-daemon clamav-freshclam}
    chef_run.node.automatic_attrs["platform_family"] = "debian"
    chef_run.node.automatic_attrs["platform"] = "ubuntu"
    chef_run.node.run_state[:seen_recipes]["apt"] = true
    Chef::Recipe.any_instance.should_receive(:apt_repository).
      with("clamav-repo")
  end

  context "an entirely default node" do
    before :each do
      chef_run.converge @rcp
    end

    it "should set up the ClamAV APT repo" do
      chef_run.should include_recipe "apt"
    end

    it "should install the pertinent packages" do
      @pkgs.each do |p|
        chef_run.should install_package p
      end
    end

    it "should not send any restart notifications" do
      @svcs.each do |s|
        @pkgs.each do |p|
          chef_run.package(p).should_not notify("service[#{s}]", :restart)
        end
      end
    end

    it "should clean up files left behind by the packages" do
      files = %w{
        /etc/logrotate.d/clamav-daemon
        /etc/logrotate.d/clamav-freshclam
      }
      files.each do |f|
        chef_run.should delete_file f
      end
    end
  end

  context "a node with the dev package enabled" do
    before :each do
      chef_run.node.set["clamav"]["dev_package"] = true
      chef_run.converge @rcp
    end

    it "should install the ClamAV dev package" do
      chef_run.should install_package "libclamav-dev"
    end
  end

  context "a node with the package versions overridden" do
    before :each do
      chef_run.node.set["clamav"]["version"] = "42.42.42"
      chef_run.converge @rcp
    end

    it "should install the packages at the specified version" do
      @pkgs.each do |p|
        chef_run.should install_package_at_version(p, "42.42.42")
      end
    end
  end

  context "a node with clamd and freshclam daemons enabled" do
    before :each do
      chef_run.node.set["clamav"]["clamd"]["enabled"] = true
      chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
      chef_run.converge @rcp
    end

    it "should send restart notifications to the services" do
      @svcs.each do |s|
        chef_run.package("clamav").should notify("service[#{s}]", :restart)
      end
      chef_run.package("clamav-daemon").should notify("service[clamav-daemon]",
        :restart)
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
