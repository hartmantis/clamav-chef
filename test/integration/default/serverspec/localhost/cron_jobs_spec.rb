# Encoding: UTF-8

require 'spec_helper'

describe 'clamav cron jobs' do
  let(:script) { '/usr/local/bin/clamav-scan.sh' }
  let(:minimal_cmd) do
    "#{script} /bin /sbin /usr/bin /usr/sbin /usr/local/bin " \
      '/usr/local/sbin /etc /root /opt /home'
  end
  let(:full_cmd) { "#{script} /" }

  it 'does not have the scan script in place' do
    expect(file(script)).to_not be_file
  end

  it 'does not have the minimal scan cron job enabled' do
    expect(cron).to_not have_entry("42 0 * * 1-6 #{minimal_cmd}")
  end

  it 'does not have the full scan cron job enabled' do
    expect(cron).to_not have_entry("42 0 * * 0 #{full_cmd}")
  end

  describe file('/etc/sysconfig/freshclam'), if: os[:family] == 'redhat' do
    it 'leaves the freshclam cron job disabled' do
      expect(subject.content).to match(/^FRESHCLAM_DELAY=disable/)
    end
  end
end
