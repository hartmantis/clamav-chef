# encoding: utf-8
# frozen_string_literal: true

files = case os[:family]
        when 'debian'
          %w[/etc/clamav/clamd.conf /etc/clamav/freshclam.conf]
        end

files.each do |f|
  describe file(f) do
    it { should_not exist }
  end
end
