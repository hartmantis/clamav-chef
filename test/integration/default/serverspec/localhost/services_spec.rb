# Encoding: UTF-8

require 'spec_helper'

describe 'clamav disabled services' do
  let(:clamd_service) do
    @node['platform_family'] == 'debian' ? 'clamav-daemon' : 'clamd'
  end
  let(:freshclam_service) do
    @node['platform_family'] == 'debian' ? 'clamav-freshclam' : 'freshclam'
  end

  it 'is not running clamd' do
    expect(service(clamd_service)).to_not be_enabled
    expect(service(clamd_service)).to_not be_running
  end

  it 'is not running freshclam' do
    expect(service(freshclam_service)).to_not be_enabled
    expect(service(freshclam_service)).to_not be_running
  end
end
