# encoding: utf-8
# frozen_string_literal: true

case os[:family]
when 'debian'
  %w(clamav-daemon clamav-freshclam).each do |s|
    describe service(s) do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end
