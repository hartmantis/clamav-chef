
require_relative '../spec_helper'

describe 'clamav::enabled::config' do
  %w[/etc/clamav/clamd.conf /etc/clamav/freshclam.conf].each do |f|
    describe file(f), if: %w[ubuntu debian].include?(os[:family]) do
      it 'exists' do
        expect(subject).to be_file
      end
    end
  end
end
