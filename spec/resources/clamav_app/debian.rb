# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav_app'

shared_context 'resources::clamav_app::debian' do
  include_context 'resources::clamav_app'

  let(:base_packages) { %w[clamav clamav-daemon clamav-freshclam] }
  let(:dev_packages) { %w[libclamav-dev] }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
