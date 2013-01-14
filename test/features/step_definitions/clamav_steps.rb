require "tempfile"

Given "a new server with ClamAV installed" do

end

Given "a new server with ClamAV enabled" do

end

When /^I manually scan a (\w+) file$/ do |file_type|
  @f = Tempfile.new("clamtesting")
  case file_type
  when "clean"
    @f.write("This file is clean")
  when "virus"
    @f.write("X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-" +
      "FILE!$H+H*")
  end
  @f.rewind
  @f.close
  File.chmod(0777, @f)
  @res = %x{clamscan #{@f.path}}
  @f.unlink
end

When /^I scan a (\w+) file via clamd$/ do |file_type|
  @f = Tempfile.new("clamtesting")
  case file_type
  when "clean"
    @f.write("This file is clean")
  when "virus"
    @f.write("X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-" +
      "FILE!$H+H*")
  end
  @f.rewind
  @f.close
  File.chmod(0777, @f)
  @res = %x{clamdscan #{@f.path}}
  @f.unlink
end

Then "ClamAV should detect nothing" do
  @res.must_include "#{@f.path}: OK"
  @res.must_include "\nInfected files: 0\n"
end

Then "ClamAV should detect a virus" do
  @res.must_include "#{@f.path}: Eicar-Test-Signature FOUND\n"
  @res.must_include "\nInfected files: 1\n"
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
