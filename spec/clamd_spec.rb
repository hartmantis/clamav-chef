require "chefspec"

describe "clamav::clamd" do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before :each do
    @rcp = "clamav::clamd"
  end

  context "a Ubuntu node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "debian"
      @conf = "/etc/clamav/clamd.conf"
      @svc = "service[clamav-daemon]"
    end

    context "an entirely default node" do
      before :each do
        chef_run.converge @rcp
      end

      it "should create clamd.conf and leave disabled services alone" do
        chef_run.should create_file @conf
        chef_run.template(@conf).should be_owned_by("clamav", "clamav")
        chef_run.template(@conf).should_not notify(@svc, :restart)
      end

      attrs = [
        # {{{ Default attributes
        "LogFile /var/log/clamav/clamd.log",
        "LogFileUnlock no",
        "LogFileUnlock no",
        "LogFileMaxSize 1M",
        "LogTime no",
        "LogClean no",
        "LogSyslog no",
        "#LogFacility LOG_MAIL",
        "LogVerbose no",
        "ExtendedDetectionInfo no",
        "PidFile /var/run/clamav/clamd.pid",
        "TemporaryDirectory /tmp",
        "DatabaseDirectory /var/lib/clamav",
        "OfficialDatabaseOnly no",
        "LocalSocket /tmp/clamd",
        "#LocalSocketGroup virusgroup",
        "#LocalSocketMode 660",
        "FixStaleSocket yes",
        "#TCPSocket 3310",
        "#TCPAddr 127.0.0.1",
        "MaxConnectionQueueLength 200",
        "StreamMaxLength 25M",
        "StreamMinPort 1024",
        "StreamMaxPort 2048",
        "MaxThreads 10",
        "ReadTimeout 120",
        "CommandReadTimeout 5",
        "SendBufTimeout 500",
        "MaxQueue 100",
        "IdleTimeout 30",
        #"ExcludePath ",
        "MaxDirectoryRecursion 15",
        "FollowDirectorySymlinks no",
        "FollowFileSymlinks no",
        "CrossFilesystems yes",
        "SelfCheck 600",
        "#VirusEvent /usr/local/bin/send_sms 123456789 \"VIRUS ALERT: %v\"",
        "User clamav",
        "AllowSupplementaryGroups no",
        "ExitOnOOM no",
        "Foreground no",
        "Debug no",
        "LeaveTemporaryFiles no",
        "DetectPUA no",
        #"ExcludePUA ",
        #"IncludePUA ",
        "AlgorithmicDetection yes",
        "ScanPE yes",
        "ScanELF yes",
        "DetectBrokenExecutables no",
        "ScanOLE2 yes",
        "OLE2BlockMacros no",
        "ScanPDF yes",
        "ScanMail yes",
        "ScanPartialMessages no",
        "PhishingSignatures yes",
        "PhishingScanURLs yes",
        "PhishingAlwaysBlockSSLMismatch no",
        "PhishingAlwaysBlockCloak no",
        "HeuristicScanPrecedence no",
        "StructuredDataDetection no",
        "#StructuredMinCreditCardCount 5",
        "#StructuredMinSSNCount 5",
        "#StructuredSSNFormatNormal yes",
        "#StructuredSSNFormatStripped yes",
        "ScanHTML yes",
        "ScanArchive yes",
        "ArchiveBlockEncrypted no",
        "MaxScanSize 100M",
        "MaxFileSize 25M",
        "MaxRecursion 16",
        "MaxFiles 10000",
        "ClamukoScanOnAccess no",
        "#ClamukoScannerCount 3",
        "#ClamukoMaxFileSize 10M",
        "#ClamukoScanOnOpen yes",
        "#ClamukoScanOnClose yes",
        "#ClamukoScanOnExec yes",
        #"ClamukoIncludePath ",
        #"ClamukoExcludePath ",
        #"ClamukoExcludeUID ",
        "Bytecode yes",
        "BytecodeSecurity TrustSigned",
        "BytecodeTimeout 5000"
        # }}}
      ]
      attrs.each do |attr|
        it "should write the default #{attr} attribute in clamd.conf" do
          chef_run.should create_file_with_content(@conf, attr)
        end
      end
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should notify clamd to restart" do
        chef_run.template(@conf).should notify(@svc, :restart)
      end
    end
  end

  context "a RHEL node" do
    before :each do
      chef_run.node.automatic_attrs["platform_family"] = "rhel"
      @conf = "/etc/clamd.conf"
      @svc = "service[clamd]"
    end

    context "an entirely default node" do
      before :each do
        chef_run.converge @rcp
      end

      it "should create clamd.conf and leave disabled services alone" do
        chef_run.should create_file @conf
        chef_run.template(@conf).should be_owned_by("clamav", "clamav")
        chef_run.template(@conf).should_not notify(@svc, :restart)
      end
    end

    context "a node with the clamd service enabled" do
      before :each do
        chef_run.node.set["clamav"]["clamd"]["enabled"] = true
        chef_run.converge @rcp
      end

      it "should notify clamd to restart" do
        chef_run.template(@conf).should notify(@svc, :restart)
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
