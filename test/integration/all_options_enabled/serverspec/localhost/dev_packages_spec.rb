# Encoding: UTF-8

require 'spec_helper'

describe 'clamav dev packages' do
  let(:pkg) do
    @node['platform_family'] == 'debian' ? 'libclamav-dev' : 'clamav-devel'
  end

  it 'is installed' do
    expect(package(pkg)).to be_installed
  end
end
