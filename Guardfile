# -*- encoding: utf-8 -*-
#
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, :all_on_start => true, :notification => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }

  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^attributes/(.+)\.rb$})
  watch(%r{^files/(.+)})
  watch(%r{^templates/(.+)})
  watch(%r{^providers/(.+)\.rb})
  watch(%r{^resources/(.+)\.rb})
end

guard :foodcritic, :cookbook_paths => '.', :cli => '-t ~FC023 -f any' do
  watch(%r{^.*\.rb$})
end

#guard :kitchen do
#  watch(%r{test/.+})
#  watch(%r{^recipes/(.+)\.rb$})
#  watch(%r{^attributes/(.+)\.rb$})
#  watch(%r{^files/(.+)})
#  watch(%r{^templates/(.+)})
#  watch(%r{^providers/(.+)\.rb})
#  watch(%r{^resources/(.+)\.rb})
#end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
