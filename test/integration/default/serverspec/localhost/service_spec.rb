# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'clamav::default::service' do
  %w(clamav-daemon clamav-freshclam).each do |s|
    describe service(s), if: %w(ubuntu debian).include?(os[:family]) do
      it 'is enabled' do
        expect(subject).to be_enabled
      end

      it 'is running' do
        expect(subject).to be_running
      end
    end
  end
end
