# Encoding: UTF-8

require 'spec_helper'

class Chef
  class Resource
    # A fake logrotate_app resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class LogrotateApp < Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :logrotate_app
        @action = :create
        @allowed_actions = [:create]
      end

      def cookbook(arg = nil)
        set_or_return(:cookbook, arg, kind_of: String)
      end

      def path(arg = nil)
        set_or_return(:path, arg, kind_of: String)
      end

      def frequency(arg = nil)
        set_or_return(:frequency, arg, kind_of: String)
      end

      def rotate(arg = nil)
        set_or_return(:rotate, arg, kind_of: Fixnum)
      end

      def create(arg = nil)
        set_or_return(:create, arg, kind_of: String)
      end
    end
  end
end
