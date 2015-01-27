# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::clamd' do
  let(:platform) { { platform: nil, version: nil } }
  let(:conf) { nil }
  let(:service) { nil }
  let(:attributes) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'drops in clamd.conf in the correct location' do
      expect(chef_run).to create_template(conf).with(
        owner: 'clamav',
        group: 'clamav',
        mode: '0644'
      )
    end
  end

  shared_examples_for 'a node with all default attributes' do
    [
      # {{{ Default attributes
      'LogFile /var/log/clamav/clamd.log',
      'LogFileUnlock no',
      'LogFileUnlock no',
      'LogFileMaxSize 10M',
      'LogTime yes',
      'LogClean no',
      'LogSyslog no',
      '#LogFacility LOG_MAIL',
      'LogVerbose yes',
      'ExtendedDetectionInfo yes',
      'PidFile /var/run/clamav/clamd.pid',
      'TemporaryDirectory /tmp',
      'DatabaseDirectory /var/lib/clamav',
      'OfficialDatabaseOnly no',
      'LocalSocket /tmp/clamd',
      '#LocalSocketGroup virusgroup',
      '#LocalSocketMode 660',
      'FixStaleSocket yes',
      '#TCPSocket 3310',
      '#TCPAddr 127.0.0.1',
      'MaxConnectionQueueLength 200',
      'StreamMaxLength 25M',
      'StreamMinPort 1024',
      'StreamMaxPort 2048',
      'MaxThreads 2',
      'ReadTimeout 120',
      'CommandReadTimeout 5',
      'SendBufTimeout 500',
      'MaxQueue 100',
      'IdleTimeout 30',
      'ExcludePath \^/proc/',
      'ExcludePath \^/sys/',
      'ExcludePath \^/dev/',
      'ExcludePath \^/var/log/clamav/',
      'MaxDirectoryRecursion 25',
      'FollowDirectorySymlinks no',
      'FollowFileSymlinks no',
      'CrossFilesystems yes',
      'SelfCheck 600',
      '#VirusEvent /usr/local/bin/send_sms 123456789 "VIRUS ALERT: %v"',
      'User clamav',
      'AllowSupplementaryGroups no',
      'ExitOnOOM no',
      'Foreground no',
      'Debug no',
      'LeaveTemporaryFiles no',
      'DetectPUA no',
      # 'ExcludePUA ',
      # 'IncludePUA ',
      'AlgorithmicDetection yes',
      'ScanPE yes',
      'ScanELF yes',
      'DetectBrokenExecutables no',
      'ScanOLE2 yes',
      'OLE2BlockMacros no',
      'ScanPDF yes',
      'ScanMail yes',
      'ScanPartialMessages no',
      'PhishingSignatures yes',
      'PhishingScanURLs yes',
      'PhishingAlwaysBlockSSLMismatch no',
      'PhishingAlwaysBlockCloak no',
      'HeuristicScanPrecedence no',
      'StructuredDataDetection no',
      '#StructuredMinCreditCardCount 5',
      '#StructuredMinSSNCount 5',
      '#StructuredSSNFormatNormal yes',
      '#StructuredSSNFormatStripped yes',
      'ScanHTML yes',
      'ScanArchive yes',
      'ArchiveBlockEncrypted no',
      'MaxScanSize 100M',
      'MaxFileSize 25M',
      'MaxRecursion 25',
      'MaxFiles 10000',
      '#ClamukoScannerCount 3',
      '#ClamukoMaxFileSize 10M',
      '#ClamukoScanOnOpen yes',
      '#ClamukoScanOnClose yes',
      '#ClamukoScanOnExec yes',
      # 'ClamukoIncludePath ',
      # 'ClamukoExcludePath ',
      # 'ClamukoExcludeUID ',
      'Bytecode yes',
      'BytecodeSecurity TrustSigned',
      'BytecodeTimeout 5000'
      # }}}
    ].each do |attr|
      it "writes the default #{attr} attribute in clamd.conf" do
        expect(chef_run).to render_file(conf).with_content(/^#{attr}$/)
      end
    end
  end

  shared_examples_for 'a node with the clamd service disabled' do
    it 'leaves disabled service alone' do
      expect(chef_run.template(conf)).to_not notify(service)
    end
  end

  shared_examples_for 'a node with the clamd service enabled' do
    it 'restarts the enabled service' do
      expect(chef_run.template(conf)).to notify(service).to(:restart)
    end
  end

  {
    Ubuntu: {
      platform: 'ubuntu',
      version: '12.04',
      conf: '/etc/clamav/clamd.conf',
      service: 'service[clamav-daemon]'
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      conf: '/etc/clamd.conf',
      service: 'service[clamd]'
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:conf) { v[:conf] }
      let(:service) { v[:service] }

      context 'an entirely default node' do
        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node with the clamd service disabled'
      end

      context 'a node with the clamd service enabled' do
        let(:attributes) { { clamav: { clamd: { enabled: true } } } }

        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node with the clamd service enabled'
      end
    end
  end
end
