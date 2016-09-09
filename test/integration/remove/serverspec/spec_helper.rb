# Encoding: UTF-8

require 'serverspec'

ENV['PATH'] = (ENV['PATH'].split(':') + %w(/sbin /usr/sbin)).uniq.join(':')

if RUBY_PLATFORM =~ /mswin|mingw32|windows/
  set :os, family: 'windows'
  set :backend, :cmd
else
  set :backend, :exec
end
