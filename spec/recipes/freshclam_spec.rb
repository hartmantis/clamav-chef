# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::freshclam' do
  let(:platform) { { platform: nil, version: nil } }
  let(:conf) { nil }
  let(:clamd_conf) { File.join(File.dirname(conf), 'clamd.conf') }
  let(:service) { nil }
  let(:attributes) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'drops freshclam.conf in the correct location' do
      expect(chef_run).to create_template(conf).with(
        owner: 'clamav',
        group: 'clamav',
        mode: '0644'
      )
    end

    it 'ensures the database directory is created' do
      expect(chef_run).to create_directory('/var/lib/clamav').with(
        owner: 'clamav',
        group: 'clamav',
        recursive: true
      )
    end
  end

  shared_examples_for 'a node with all default attributes' do
    attrs = [
      # {{{ Default attributes
      'DatabaseDirectory /var/lib/clamav',
      'UpdateLogFile /var/log/clamav/freshclam.log',
      'LogFileMaxSize 1M',
      'LogTime no',
      'LogVerbose no',
      'LogSyslog no',
      '#LogFacility LOG_MAIL',
      'PidFile /var/run/clamav/freshclam.pid',
      'DatabaseOwner clamav',
      'AllowSupplementaryGroups no',
      'DNSDatabaseInfo current.cvd.clamav.net',
      'DatabaseMirror database.clamav.net',
      'MaxAttempts 3',
      'ScriptedUpdates yes',
      'CompressLocalDatabase no',
      # 'DatabaseCustomURL',
      'Checks 12',
      '#HTTPProxyServer myproxy.com',
      '#HTTPProxyPort 1234',
      '#HTTPProxyUsername myusername',
      '#HTTPProxyPassword mypass',
      '#HTTPUserAgent SomeUserAgentIdString',
      '#LocalIPAddress aaa.bbb.ccc.ddd',
      '#OnUpdateExecute command',
      '#OnErrorExecute command',
      '#OnOutdatedExecute command',
      'Foreground no',
      'Debug no',
      'ConnectTimeout 30',
      'ReceiveTimeout 30',
      'TestDatabases yes',
      '#SubmitDetectionStats /path/to/clamd.conf',
      '#DetectionStatsCountry country-code',
      '#DetectionStatsHostID unique-id',
      '#SafeBrowsing yes',
      'Bytecode yes'
      # 'ExtraDatabase"
      # }}}
    ]
    attrs.each do |attr|
      it "writes the default #{attr} attribute in freshclam.conf" do
        expect(chef_run).to render_file(conf).with_content(/^#{attr}$/)
      end
    end
  end

  shared_examples_for 'a node that needs to run freshclam' do
    it 'runs freshclam manually' do
      expect(chef_run).to run_execute('freshclam').with(
        creates: '/var/lib/clamav/daily.cvd'
      )
    end
  end

  shared_examples_for 'a node that does not need to run freshclam' do
    it 'does not run freshclam manually' do
      expect(chef_run).to_not run_execute('freshclam')
    end
  end

  shared_examples_for 'a node with the freshclam service disabled' do
    it 'leaves disabled service alone' do
      expect(chef_run.template(conf)).to_not notify(service).to(:restart)
    end
  end

  shared_examples_for 'a node with the freshclam service enabled' do
    it 'restarts the enabled service' do
      expect(chef_run.template(conf)).to notify(service).to(:restart)
    end
  end

  shared_examples_for 'a node with the clamd service disabled' do
    it 'is not configured to send update notifications to clamav' do
      content = '#NotifyClamd /etc/clamd.conf'
      expect(chef_run).to render_file(conf).with_content(/^#{content}$/)
    end
  end

  shared_examples_for 'a node with the clamd service enabled' do
    it 'is configured to send update notifications to clamav' do
      content = "NotifyClamd #{clamd_conf}"
      expect(chef_run).to render_file(conf).with_content(/^#{content}$/)
    end
  end

  {
    Ubuntu: {
      platform: 'ubuntu',
      version: '12.04',
      conf: '/etc/clamav/freshclam.conf',
      service: 'service[clamav-freshclam]'
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      conf: '/etc/freshclam.conf',
      service: 'service[freshclam]'
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:conf) { v[:conf] }
      let(:service) { v[:service] }

      context 'an entirely default node' do
        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node that needs to run freshclam'
        it_behaves_like 'a node with the freshclam service disabled'
        it_behaves_like 'a node with the clamd service disabled'
      end

      context 'a node with the freshclam service enabled' do
        let(:attributes) { { clamav: { freshclam: { enabled: true } } } }

        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node that needs to run freshclam'
        it_behaves_like 'a node with the freshclam service enabled'
        it_behaves_like 'a node with the clamd service disabled'
      end

      context 'a node with the clamd service enabled' do
        let(:attributes) { { clamav: { clamd: { enabled: true } } } }

        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node that needs to run freshclam'
        it_behaves_like 'a node with the freshclam service disabled'
        it_behaves_like 'a node with the clamd service enabled'
      end

      context 'a node with the initial freshclam run disabled' do
        let(:attributes) do
          { clamav: { freshclam: { skip_initial_run: true } } }
        end

        it_behaves_like 'any node'
        it_behaves_like 'a node with all default attributes'
        it_behaves_like 'a node that does not need to run freshclam'
        it_behaves_like 'a node with the freshclam service disabled'
        it_behaves_like 'a node with the clamd service disabled'
      end
    end
  end
end
