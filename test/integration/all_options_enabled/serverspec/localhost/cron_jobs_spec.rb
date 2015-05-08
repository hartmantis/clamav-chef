# Encoding: UTF-8

require 'spec_helper'

describe 'clamav cron jobs' do
  let(:script) { '/usr/local/bin/clamav-scan.sh' }
  let(:min_file) { '/etc/cron.d/clamav_minimal_scan' }
  let(:min_cmd) do
    "#{script} /bin /sbin /usr/bin /usr/sbin /usr/local/bin " \
      '/usr/local/sbin /etc /root /opt /home'
  end
  let(:full_file) { '/etc/cron.d/clamav_full_scan' }
  let(:full_cmd) { "#{script} /" }

  it 'has the scan script in place' do
    expect(file(script)).to be_file
  end

  it 'has the minimal scan cron job enabled' do
    expect(file(min_file).content).to include("42 0 * * 1-6 root #{min_cmd}")
  end

  it 'has the full scan cron job enabled' do
    expect(file(full_file).content).to include("42 0 * * 0 root #{full_cmd}")
  end

  describe file('/etc/sysconfig/freshclam'), if: os[:family] == 'redhat' do
    it 'enables the freshclam cron job' do
      expect(subject.content).not_to match(/^FRESHCLAM_DELAY=disabled/)
    end
  end
end
