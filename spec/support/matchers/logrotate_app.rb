# Encoding: UTF-8

require 'spec_helper'

module ChefSpec
  module API
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
end
