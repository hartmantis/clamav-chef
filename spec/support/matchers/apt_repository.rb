# -*- encoding: utf-8 -*-

require 'spec_helper'

module ChefSpec::API
  # Some simple matchers for the apt_repository resource
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module AptRepositoryMatchers
    ChefSpec::Runner.define_runner_method :apt_repository

    def create_apt_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:apt_repository,
                                              :create,
                                              resource_name)
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
