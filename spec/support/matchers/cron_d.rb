# Encoding: UTF-8

require 'spec_helper'

module ChefSpec
  module API
    # Some simple matchers for the cron_d resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module CronDMatchers
      ChefSpec::Runner.define_runner_method :cron_d

      def create_cron_d(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:cron_d, :create, resource_name)
      end
    end
  end
end
