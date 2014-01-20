# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav syslog logging' do
  let(:syslog_file) do
    "/var/log/#{@node['platform_family'] == 'debian' ? 'syslog' : '/messages'}"
  end
  let(:syslog) { File.read(syslog_file) }

  it 'is writing clamav logs to the system log' do
    expect(file(f)).to contain(' clamd[')
  end

  it 'is writing freshclam logs to the system log' do
    expect(file(f)).to contain(' freshclam[')
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
