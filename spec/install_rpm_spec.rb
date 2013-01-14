require "chefspec"

describe "clamav::install_rpm" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::install_rpm"
    @pkgs = %w{clamav clamav-db clamd}
    @svcs = %w{clamd freshclam}
    chef_run.node.automatic_attrs["platform_family"] = "rhel"
    chef_run.node.run_state[:seen_recipes]["yum::epel"] = true
  end

  context "an entirely default node" do
    before :each do
      chef_run.converge @rcp
    end

    it "should include the EPEL recipe" do
      chef_run.should include_recipe "yum::epel"
    end

    it "should install the pertinent packages" do
      @pkgs.each do |p|
        chef_run.yum_package(p).should be
      end
    end

    it "should not send any restart notifications" do
      @svcs.each do |s|
        @pkgs.each do |p|
          chef_run.yum_package(p).should_not notify("service[#{s}]", :restart)
        end
      end
    end

    it "should template out the init scripts" do
      @svcs.each do |s|
        chef_run.should create_file "/etc/init.d/#{s}"
      end
    end

    it "should clean up the bad user the RPMs create" do
      chef_run.should remove_user "clam"
    end
  end

  context "a node with the dev package enabled" do
    before :each do
      chef_run.node.set["clamav"]["dev_package"] = true
      chef_run.converge @rcp
    end

    it "should install the ClamAV dev package" do
      chef_run.yum_package("clamav-devel").should be
    end
  end

  context "a node with the package versions overridden" do
    before :each do
      chef_run.node.set["clamav"]["version"] = "42.42.42"
      chef_run.converge @rcp
    end

    it "should install the packages at the specified version" do
      @pkgs.each do |p|
        chef_run.yum_package(p).version.should == "42.42.42"
      end
    end
  end

  context "a node with the clamd and freshclam daemons enabled" do
    before :each do
      chef_run.node.set["clamav"]["clamd"]["enabled"] = true
      chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
      chef_run.converge @rcp
    end

    it "should send restart notifications to the services" do
      @svcs.each do |s|
        @pkgs.each do |p|
          chef_run.yum_package(p).should notify("service[#{s}]", :restart)
        end
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
