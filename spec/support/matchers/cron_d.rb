# Encoding: UTF-8

require 'spec_helper'

if defined?(ChefSpec)
  ChefSpec.define_matcher(:cron_d)

  def create_cron_d(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:cron_d, :create, resource_name)
  end
end
