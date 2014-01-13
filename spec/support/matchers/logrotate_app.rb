# -*- encoding: utf-8 -*-

require 'spec_helper'

module ChefSpec::API
  # Some simple matchers for the logrotate_app resource
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module LogrotateAppMatchers
    ChefSpec::Runner.define_runner_method :logrotate_app

    def create_logrotate_app(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:logrotate_app,
                                              :create,
                                              resource_name)
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
