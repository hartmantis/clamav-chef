# encoding: utf-8
# frozen_string_literal: true

case os[:family]
when 'debian'
  %w[/etc/clamav/clamd.conf /etc/clamav/freshclam.conf].each do |f|
    describe file(f) do
      it { should exist }
      its(:owner) { should eq('clamav') }
      its(:group) { should eq('clamav') }
      its(:mode) { should cmp('0644') }
    end
  end
end
