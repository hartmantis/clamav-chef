# Encoding: UTF-8

require 'spec_helper'

describe 'clamav logging' do
  let(:rotators) do
    {
      '/etc/logrotate.d/clamav' => '/var/log/clamav/clamd.log',
      '/etc/logrotate.d/freshclam' => '/var/log/clamav/freshclam.log'
    }
  end

  it 'has logrotate configs' do
    rotators.each { |conf, _| expect(file(conf)).to be_file }
  end

  it 'has valid logrotate configs' do
    rotators.each do |conf, _|
      expect(command("logrotate -d #{conf}").exit_status).to eq(0)
    end
  end

  it 'is configured to rotate the ClamAV logs' do
    rotators.each do |conf, file|
      expected = /considering log #{file}/
      expect(command("logrotate -d #{conf} 2>&1").stdout).to match(expected)
    end
  end

  it 'has unused package default users removed' do
    expect(user('clam')).to_not exist
  end
end
