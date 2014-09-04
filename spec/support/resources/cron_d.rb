# Encoding: UTF-8

require 'spec_helper'

class Chef
  class Resource
    # A fake cron_d resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class CronD < Cron
      def initialize(name, run_context = nil)
        super
        @resource_name = :cron_d
      end
    end
  end
end
