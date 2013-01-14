require "chefspec"

describe "clamav::freshclam" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::freshclam"
  end

  context "a Ubuntu node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "debian"
      @conf = "/etc/clamav/freshclam.conf"
      @svc = "service[clamav-freshclam]"
    end

    context "an entirely default node" do
      before :each do
        chef_run.converge @rcp
      end

      it "should create freshclam.conf and leave disabled services alone" do
        chef_run.should create_file @conf
        chef_run.template(@conf).should be_owned_by("clamav", "clamav")
        chef_run.template(@conf).should_not notify(@svc, :restart)
      end

      attrs = [
        # {{{ Default attributes
        "DatabaseDirectory /var/lib/clamav",
        "UpdateLogFile /var/log/clamav/freshclam.log",
        "LogFileMaxSize 1M",
        "LogTime no",
        "LogVerbose no",
        "LogSyslog no",
        "#LogFacility LOG_MAIL",
        "PidFile /var/run/clamav/freshclam.pid",
        "DatabaseOwner clamav",
        "AllowSupplementaryGroups no",
        "DNSDatabaseInfo current.cvd.clamav.net",
        "DatabaseMirror database.clamav.net",
        "MaxAttempts 3",
        "ScriptedUpdates yes",
        "CompressLocalDatabase no",
        #"DatabaseCustomURL",
        "Checks 12",
        "#HTTPProxyServer myproxy.com",
        "#HTTPProxyPort 1234",
        "#HTTPProxyUsername myusername",
        "#HTTPProxyPassword mypass",
        "#HTTPUserAgent SomeUserAgentIdString",
        "#LocalIPAddress aaa.bbb.ccc.ddd",
        "#NotifyClamd /etc/clamd.conf",
        "#OnUpdateExecute command",
        "#OnErrorExecute command",
        "#OnOutdatedExecute command",
        "Foreground no",
        "Debug no",
        "ConnectTimeout 30",
        "ReceiveTimeout 30",
        "TestDatabases yes",
        "#SubmitDetectionStats /path/to/clamd.conf",
        "#DetectionStatsCountry country-code",
        "#DetectionStatsHostID unique-id",
        "#SafeBrowsing yes",
        "Bytecode yes"
        #"ExtraDatabase"
        # }}}
      ]
      attrs.each do |attr|
        it "should write the default #{attr} attribute in freshclam.conf" do
          chef_run.should create_file_with_content(@conf, attr)
        end
      end
    end

    context "a node with the freshclam service enabled" do
      before :each do
        chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should create freshclam.conf and restart enabled services" do
        chef_run.should create_file @conf
        chef_run.template(@conf).should be_owned_by("clamav", "clamav")
        chef_run.template(@conf).should notify(@svc, :restart)
      end

      it "should call freshclam on initial install" do
        chef_run.should execute_command "freshclam"
      end
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should send update notifications to clamd" do
        chef_run.should create_file_with_content(@conf,
          "NotifyClamd /etc/clamav/clamd.conf")
      end
    end
  end

  context "a RHEL node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "rhel"
      @conf = "/etc/freshclam.conf"
      @svc = "service[freshclam]"
    end

    context "an entirely default node" do
      before :each do
        chef_run.converge @rcp
      end

      it "should create freshclam.conf and leave disabled services alone" do
        chef_run.should create_file @conf
        chef_run.template(@conf).should be_owned_by("clamav", "clamav")
        chef_run.template(@conf).should_not notify(@svc, :restart)
      end
    end

    context "a node with the freshclam service enabled" do
      before :each do
        chef_run.node.set["clamav"]["freshclam"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should notify freshclam to restart" do
        chef_run.template(@conf).should notify(@svc, :restart)
      end
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should send update notifications to clamd" do
        chef_run.should create_file_with_content(@conf,
          "NotifyClamd /etc/clamd.conf")
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
