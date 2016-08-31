# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav_config'

describe 'resources::clamav_config::debian' do
  include_context 'resources::clamav_config'

  let(:config_dir) { '/etc/clamav' }
  let(:user) { 'clamav' }
  let(:group) { 'clamav' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
