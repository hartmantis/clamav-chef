require "chefspec"

describe "clamav::default" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @includes = %w{
      clamav::users
      clamav::logging 
      clamav::freshclam
      clamav::clamd 
      clamav::freshclam_service
      clamav::clamd_service
    }
    (@includes + %w{clamav::install_rpm clamav::install_deb}).each do |i|
      chef_run.node.run_state.seen_recipes[i] = true
    end
    @rcp = "clamav::default"
  end

  context "a Ubuntu node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "debian"
      chef_run.converge @rcp
    end

    it "should include all the default recipes" do
      @includes.each do |i|
        chef_run.should include_recipe i
      end
    end

    it "should include the DEB install recipe" do
      chef_run.should include_recipe "clamav::install_deb"
    end
  end

  context "a RHEL node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "rhel"
      chef_run.converge @rcp
    end

    it "should include the RPM install recipe" do
      chef_run.should include_recipe "clamav::install_rpm"
    end
  end

  context "a node of unsupported platform family" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "Windows"
      chef_run.node.automatic_attrs["platform"] = "Windows XP"
    end

    it "should raise an unsupported exception" do
      Chef::Formatters::Base.any_instance.stub(:file_load_failed)
      expect { chef_run.converge @rcp }.to raise_error(
        Chef::Exceptions::UnsupportedAction,
        "Cookbook does not support Windows XP platform")
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
