# encoding: utf-8
# frozen_string_literal: true

pkgs = case os[:family]
       when 'debian'
         %w(libclamav-dev)
       end

pkgs.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end
