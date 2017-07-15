# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

case os[:family]
when 'debian'
  %w[clamav-daemon clamav-freshclam].each do |s|
    describe service(s) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
