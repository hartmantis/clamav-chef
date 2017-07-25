# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav_update'

shared_context 'resources::clamav_update::debian' do
  include_context 'resources::clamav_update'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
