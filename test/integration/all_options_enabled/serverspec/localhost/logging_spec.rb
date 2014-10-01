# Encoding: UTF-8

require 'spec_helper'

describe 'clamav syslog logging' do
  let(:syslog_file) do
    "/var/log/#{os[:family] == 'ubuntu' ? 'syslog' : '/messages'}"
  end
  let(:syslog) { File.read(syslog_file) }

  it 'is writing clamav logs to the system log' do
    expect(file(syslog_file)).to contain(/ clamd\[/)
  end

  it 'is writing freshclam logs to the system log' do
    expect(file(syslog_file)).to contain(/ freshclam\[/)
  end
end
