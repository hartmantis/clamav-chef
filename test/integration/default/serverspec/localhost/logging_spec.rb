# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav logging' do
  let(:log_files) do
    %w{/var/log/clamav/clamd.log /var/log/clamav/freshclam.log}
  end
  let(:logrotate_files) do
    %x{logrotate -d /etc/logrotate.conf 2>&1}.lines.collect |l|
      l.split(' ')[2] if l.start_with?('considering log ')
    end.compact
  end

  it 'has a valid logrotate config' do
    log_files.each { |f| expect(logrotate_files).to include(f) }
  end

  it 'has correct log file ownership' do
    log_files.each { |f| expect(file(f)).to be_file }
  end

  it 'has unused package default users removed' do
    expect(user('clam')).to_not exist
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
