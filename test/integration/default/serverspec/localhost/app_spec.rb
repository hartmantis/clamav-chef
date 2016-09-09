# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'clamav::default::app' do
  describe package('clamav') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  %w(clamav-daemon clamav-freshclam).each do |p|
    describe package(p), if: %w(ubuntu debian).include?(os[:family]) do
      it 'is installed' do
        expect(subject).to be_installed
      end
    end
  end

  describe package('libclamav-dev'),
           if: %w(ubuntu debian).include?(os[:family]) do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
