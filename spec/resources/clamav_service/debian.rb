# encoding: utf-8
# frozen_string_literal: true

require_relative '../clamav_service'

shared_context 'resources::clamav_service::debian' do
  include_context 'resources::clamav_service'

  let(:data_dir) { '/var/lib/clamav' }
  let(:clamd_service) { 'clamav-daemon' }
  let(:freshclam_service) { 'clamav-freshclam' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
