# Encoding: UTF-8

require 'spec_helper'

describe 'clamav user' do
  let(:usr) { 'clamav' }

  it 'is created' do
    expect(user(usr)).to exist
    expect(group(usr)).to exist
  end

  it 'has unused package default users removed' do
    expect(user('clam')).to_not exist
  end
end
