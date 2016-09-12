# encoding: utf-8
# frozen_string_literal: true

require 'serverspec'

ENV['PATH'] = (ENV['PATH'].split(':') + %w(/sbin /usr/sbin)).uniq.join(':')

if RUBY_PLATFORM =~ /mswin|mingw32|windows/
  set :os, family: 'windows'
  set :backend, :cmd
else
  set :backend, :exec
end
