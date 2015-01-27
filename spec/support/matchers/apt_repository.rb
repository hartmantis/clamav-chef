# Encoding: UTF-8

require 'spec_helper'

if defined?(ChefSpec)
  ChefSpec.define_matcher(:apt_repository)

  def create_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository,
                                            :create,
                                            resource_name)
  end
end
