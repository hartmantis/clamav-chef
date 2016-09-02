# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::clamav_service::ubuntu::14_04' do
  include_context 'resources::clamav_service::debian'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  it_behaves_like 'any Debian platform'
end
