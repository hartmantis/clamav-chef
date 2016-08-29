# encoding: utf-8
# frozen_string_literal: true

require_relative '../../clamav_config'

describe 'resources::clamav_config::ubuntu::14_04' do
  include_context 'resources::clamav_config'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }
  let(:config_dir) { '/etc/clamav' }
  let(:user) { 'clamav' }
  let(:group) { 'clamav' }

  it_behaves_like 'any platform'
end
