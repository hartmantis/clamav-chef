# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'clamav::remove::service' do
  %w(clamav-daemon clamav-freshclam).each do |s|
    describe service(s), if: %w(ubuntu debian).include?(os[:family]) do
      it 'is not enabled' do
        expect(subject).to_not be_enabled
      end

      it 'is not running' do
        expect(subject).to_not be_running
      end
    end
  end
end
