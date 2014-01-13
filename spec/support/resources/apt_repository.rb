# -*- encoding: utf-8 -*-

require 'spec_helper'

class Chef
  class Resource
    # A fake apt_repository resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class AptRepository < Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :apt_repository
        @action = :create
        @allowed_actions = [:create]
      end

      def uri(arg = nil)
        set_or_return(:uri, arg, kind_of: String)
      end

      def distribution(arg = nil)
        set_or_return(:distribution, arg, kind_of: String)
      end

      def components(arg = nil)
        set_or_return(:components, arg, kind_of: Array)
      end

      def keyserver(arg = nil)
        set_or_return(:keyserver, arg, kind_of: String)
      end

      def key(arg = nil)
        set_or_return(:key, arg, kind_of: String)
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
