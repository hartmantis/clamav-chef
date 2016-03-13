# Encoding: UTF-8

require '../spec_helper'

describe 'clamav::remove::config' do
  %w(/etc/clamav/clamd.conf /etc/clamav/freshclam.conf).each do |f|
    describe file(f), if: %w(ubuntu debian).include?(os[:family]) do
      it 'does not exist' do
        expect(subject).to_not be_file
      end
    end
  end
end
