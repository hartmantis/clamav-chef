require "chefspec"

describe "clamav::freshclam_service" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::freshclam_service"
  end

  context "a Ubuntu node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "debian"
      @svc = "clamav-freshclam"
    end

    context "a node with the freshclam service disabled (default)" do
      before :each do
        chef_run.converge @rcp
      end

      it "should create the dir for the PID files" do
        d = "/var/run/clamav"
        chef_run.should create_directory d
        chef_run.directory(d).should be_owned_by("clamav", "clamav")
      end

      it "should disable freshclam" do
        chef_run.should_not set_service_to_start_on_boot @svc
        chef_run.should stop_service @svc
      end
    end

    context "a node with the freshclam service enabled" do
      before :each do
        chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should enable freschlam" do
        chef_run.should set_service_to_start_on_boot @svc
        chef_run.should start_service @svc
      end
    end
  end

  context "a RHEL node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "rhel"
      @svc = "freshclam"
    end

    context "a node with the freshclam service enabled" do
      before :each do
        chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should enable freshclam" do
        chef_run.should set_service_to_start_on_boot @svc
        chef_run.should start_service @svc
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
