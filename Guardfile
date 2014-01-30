# -*- encoding: utf-8 -*-
#
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, all_on_start: true, notification: false do
  watch(/^spec\/.+_spec\.rb$/)
  watch('spec/spec_helper.rb')  { 'spec' }

  watch(/^recipes\/(.+)\.rb$/) { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^attributes\/(.+)\.rb$/)
  watch(/^files\/(.+)/)
  watch(/^templates\/(.+)/)
  watch(/^providers\/(.+)\.rb/)
  watch(/^resources\/(.+)\.rb/)
end

guard :foodcritic, cookbook_paths: '.', cli: '-t ~FC023 -f any' do
  watch(/^.*\.rb$/)
end

# guard :kitchen do
#   watch(/test\/.+/)
#   watch(/^recipes\/(.+)\.rb$/)
#   watch(/^attributes\/(.+)\.rb$/)
#   watch(/^files\/(.+)/)
#   watch(/^templates\/(.+)/)
#   watch(/^providers\/(.+)\.rb/)
#   watch(/^resources\/(.+)\.rb/)
# end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
