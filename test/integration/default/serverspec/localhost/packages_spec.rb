# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav packages' do
  let(:packages) do
    case @node['platform_family']
    when 'debian'
      %w{clamav clamav-daemon}
    else
      %w{clamav clamav-db clamd}
    end
  end

  it 'is installed' do
    packages.each { |p| expect(package(p)).to be_installed }
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
