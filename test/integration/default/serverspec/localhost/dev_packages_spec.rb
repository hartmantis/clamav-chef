# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav dev packages' do
  let(:pkg) do
    @node['platform_family'] == 'debian' ? 'libclamav-dev' : 'clamav-devel'
  end

  it 'is not installed' do
    expect(package(pkg)).to_not be_installed
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
