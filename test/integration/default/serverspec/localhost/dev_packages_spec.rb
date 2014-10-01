# Encoding: UTF-8

require 'spec_helper'

describe 'clamav dev packages' do
  let(:pkg) do
    os[:family] == 'ubuntu' ? 'libclamav-dev' : 'clamav-devel'
  end

  it 'is not installed' do
    expect(package(pkg)).to_not be_installed
  end
end
