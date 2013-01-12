require "chefspec"

describe 'clamav::logging' do
  let (:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::logging"
    chef_run.node.run_state[:seen_recipes]["logrotate"] = true
    @log_dirs = %w{/var/log/clamav}
    @log_files = %w{/var/log/clamav/clamd.log /var/log/clamav/freshclam.log}
  end

  context "an entirely default node" do
    before :each do
      Chef::Recipe.any_instance.should_receive(:logrotate_app).
        with("clamav").and_yield
      Chef::Recipe.any_instance.should_receive(:cookbook).with("logrotate")
      Chef::Recipe.any_instance.should_receive(:path).
        with("/var/log/clamav/clamd.log")
      Chef::Recipe.any_instance.should_receive(:frequency).with("daily")
      Chef::Recipe.any_instance.should_receive(:rotate).with(7)
      Chef::Recipe.any_instance.should_receive(:create).
        with("644 clamav clamav")

      Chef::Recipe.any_instance.should_receive(:logrotate_app).
        with("freshclam").and_yield
      Chef::Recipe.any_instance.should_receive(:cookbook).with("logrotate")
      Chef::Recipe.any_instance.should_receive(:path).
        with("/var/log/clamav/freshclam.log")
      Chef::Recipe.any_instance.should_receive(:frequency).with("daily")
      Chef::Recipe.any_instance.should_receive(:rotate).with(7)
      Chef::Recipe.any_instance.should_receive(:create).
        with("644 clamav clamav")
      chef_run.converge @rcp
    end

    it "should add two logrotate configs" do
      chef_run.should include_recipe "logrotate"
    end

    it "should create the ClamAV logging directories" do
      @log_dirs.each do |d|
        chef_run.should create_directory d
        chef_run.directory(d).should be_owned_by("clamav", "clamav")
      end
    end

    it "should fix the ownership on the ClamAV log files" do
      @log_files.each do |f|
        chef_run.should create_file f
        chef_run.file(f).should be_owned_by("clamav", "clamav")
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
