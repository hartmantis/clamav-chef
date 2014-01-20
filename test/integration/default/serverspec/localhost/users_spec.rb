# -*- encoding: utf-8 -*-

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

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
