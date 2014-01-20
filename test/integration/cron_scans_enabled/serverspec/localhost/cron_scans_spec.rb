# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav cron scans' do
  let(:script) { '/usr/local/bin/clamav-scan.sh' }
  let(:minimal_cmd) do
    "#{script} /bin /sbin /usr/bin /usr/sbin /usr/local/bin " +
      '/usr/local/sbin /etc /root /opt /home'
  end
  let(:full_cmd) { "#{script} /" }

  it 'has the scan script in place' do
    expect(file(script)).to be_file
  end

  it 'has the minimal scan cron job enabled' do
    expect(cron).to have_entry("42 0 * * 1-6 #{minimal_cmd}")
  end

  it 'has the full scan cron job enabled' do
    expect(cron).to have_entry("42 0 * * 0 #{full_cmd}")
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
