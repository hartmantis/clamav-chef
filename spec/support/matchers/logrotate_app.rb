# Encoding: UTF-8

require 'spec_helper'

if defined?(ChefSpec)
  ChefSpec.define_matcher(:logrotate_app)

  def create_logrotate_app(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:logrotate_app,
                                            :create,
                                            resource_name)
  end
end
