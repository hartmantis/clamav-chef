# Encoding: UTF-8

require 'spec_helper'

describe 'clamav logging' do
  let(:log_files) do
    %w(/var/log/clamav/clamd.log /var/log/clamav/freshclam.log)
  end
  let(:cmd) { 'logrotate -d /etc/logrotate.conf 2>&1' }

  it 'has a valid logrotate config' do
    expect(command(cmd).exit_status).to eq(0)
  end

  it 'is configured to rotate the ClamAV logs' do
    res = command(cmd)
    log_files.each do |f|
      expect(res.stdout).to match(/considering log #{f}/)
    end
  end

  it 'has correct log file ownership' do
    log_files.each { |f| expect(file(f)).to be_file }
  end

  it 'has unused package default users removed' do
    expect(user('clam')).to_not exist
  end
end
