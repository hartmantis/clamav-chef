require "chefspec"

describe "clamav::clamd_service" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::clamd_service"
  end

  context "a Ubuntu node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "debian"
      @svc = "clamav-daemon"
    end

    context "a node with the clamd service disabled (default)" do
      before :each do
        chef_run.converge @rcp
      end

      it "should disable clamd" do
        chef_run.should_not set_service_to_start_on_boot @svc
        chef_run.should stop_service @svc
      end
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should enable clamd" do
        chef_run.should set_service_to_start_on_boot @svc
        chef_run.should start_service @svc
      end
    end
  end

  context "a RHEL node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "rhel"
      @svc = "clamd"
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should enable clamd" do
        chef_run.should set_service_to_start_on_boot @svc
        chef_run.should start_service @svc
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
