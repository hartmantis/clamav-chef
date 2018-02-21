
require_relative '../spec_helper'

describe 'clamav::remove::app' do
  describe package('clamav') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end

  %w[clamav-daemon clamav-freshclam libclamav-dev].each do |p|
    describe package(p), if: %w[ubuntu debian].include?(os[:family]) do
      it 'is not installed' do
        expect(subject).to_not be_installed
      end
    end
  end
end
