# Encoding: UTF-8

require 'spec_helper'

describe 'clamav dev packages' do
  let(:pkg) do
    os[:family] == 'ubuntu' ? 'libclamav-dev' : 'clamav-devel'
  end

  it 'is installed' do
    expect(package(pkg)).to be_installed
  end
end
