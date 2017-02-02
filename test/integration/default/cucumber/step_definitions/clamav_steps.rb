# Encoding: UTF-8

require 'tempfile'

Given 'a new server with ClamAV installed' do
end

When(/^I manually scan a (\w+) file$/) do |file_type|
  @f = Tempfile.new('clamtesting')
  case file_type
  when 'clean'
    @f.write('This file is clean')
  when 'virus'
    @f.write('X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-' \
      'TEST-FILE!$H+H*')
  end
  @f.rewind
  @f.close
  File.chmod(0o777, @f)
  @res = `clamscan #{@f.path}`
  @f.unlink
end

Then 'ClamAV detects nothing' do
  expect(@res).to include("#{@f.path}: OK")
  expect(@res).to include("\nInfected files: 0\n")
end

Then 'ClamAV detects a virus' do
  expect(@res).to include("#{@f.path}: Eicar-Test-Signature FOUND\n")
  expect(@res).to include("\nInfected files: 1\n")
end
