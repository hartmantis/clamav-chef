# encoding: utf-8
# frozen_string_literal: true

inspec.command('echo "This file is clean" > /tmp/clamtest_clean').stdout
inspec.command('echo \'X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-' \
               'ANTIVIRUS-TEST-FILE!$H+H*\' > /tmp/clamtest_infected').stdout

describe command('clamscan /tmp/clamtest_clean') do
  its(:exit_status) { should eq(0) }
  its(:stdout) { should match(%r{^/tmp/clamtest_clean: OK$}) }
  its(:stdout) { should match(/^Infected files: 0$/) }
end

describe command('clamscan /tmp/clamtest_infected') do
  its(:exit_status) { should eq(1) }
  its(:stdout) do
    should match(%r{/tmp/clamtest_infected: Eicar-Test-Signature FOUND$})
  end
  its(:stdout) { should match(/^Infected files: 1$/) }
end
