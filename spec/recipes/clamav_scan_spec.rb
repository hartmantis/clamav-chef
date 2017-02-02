# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::clamav_scan' do
  let(:script) { '/usr/local/bin/clamav-scan.sh' }
  let(:attributes) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      attributes.each { |k, v| node.override[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'an entirely default node' do
    it 'does not drop in the scan script' do
      expect(chef_run).to_not create_cookbook_file(script)
    end

    it 'does not create the minimal scan job' do
      expect(chef_run).to_not create_cron_d('clamav_minimal_scan')
    end

    it 'does not create the full scan job' do
      expect(chef_run).to_not create_cron_d('clamav_full_scan')
    end
  end

  context 'a node with the clam cron scans enabled' do
    let(:attributes) do
      {
        clamav: {
          scan: {
            script: { enable: true },
            minimal: { enable: true },
            full: { enable: true }
          }
        }
      }
    end

    it 'drops in the scan script' do
      expect(chef_run).to create_cookbook_file(script).with(
        owner: 'clamav',
        group: 'clamav',
        mode: '0555'
      )
    end

    it 'does creates the minimal scan job' do
      expect(chef_run).to create_cron_d('clamav_minimal_scan').with(
        minute: '42',
        hour: '0',
        weekday: '1-6',
        user: 'root',
        mailto: 'example@example.com',
        command: "#{script} /bin /sbin /usr/bin /usr/sbin /usr/local/bin " \
          '/usr/local/sbin /etc /root /opt /home'
      )
    end

    it 'creates the full scan job' do
      expect(chef_run).to create_cron_d('clamav_full_scan').with(
        minute: '42',
        hour: '0',
        weekday: '0',
        user: 'root',
        mailto: 'example@example.com',
        command: "#{script} /"
      )
    end
  end
end
