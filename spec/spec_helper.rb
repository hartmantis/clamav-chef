# -*- encoding: utf-8 -*-

require 'chef'
require 'chefspec'
require 'tmpdir'
require 'fileutils'
require 'support/resources/apt_repository'
require 'support/resources/cron_d'
require 'support/resources/logrotate_app'
require 'support/matchers/apt_repository'
require 'support/matchers/cron_d'
require 'support/matchers/logrotate_app'

RSpec.configure do |c|
  c.color_enabled = true

  c.before(:suite) do
    COOKBOOK_PATH = Dir.mktmpdir 'chefspec'
    metadata = Chef::Cookbook::Metadata.new
    metadata.from_file(File.expand_path('../../metadata.rb', __FILE__))
    link_path = File.join(COOKBOOK_PATH, metadata.name)
    FileUtils.ln_s(File.expand_path('../..', __FILE__), link_path)
    c.cookbook_path = COOKBOOK_PATH
  end

  c.before(:each) do
    # Don't worry about external cookbook dependencies
    Chef::Cookbook::Metadata.any_instance.stub(:depends)

    Chef::ResourceCollection.any_instance.stub(:lookup).and_call_original

    # Test each recipe in isolation, regardless of includes
    @included_recipes = []
    Chef::RunContext.any_instance.stub(:loaded_recipe?).and_return(false)
    Chef::Recipe.any_instance.stub(:include_recipe) do |i|
      # Recipes that define services are a special case
      case i
      when 'clamav::clamd_service'
        Chef::ResourceCollection.any_instance.stub(:lookup)
          .with('service[clamd]')
          .and_return(Chef::Resource::Service.new('clamd'))
        Chef::ResourceCollection.any_instance.stub(:lookup)
          .with('service[clamav-daemon]')
          .and_return(Chef::Resource::Service.new('clamav-daemon'))
      when 'clamav::freshclam_service'
        Chef::ResourceCollection.any_instance.stub(:lookup)
          .with('service[freshclam]')
          .and_return(Chef::Resource::Service.new('freshclam'))
        Chef::ResourceCollection.any_instance.stub(:lookup)
          .with('service[clamav-freshclam]')
          .and_return(Chef::Resource::Service.new('clamav-freshclam'))
      end

      Chef::RunContext.any_instance.stub(:loaded_recipe?).with(i).and_return(
        true)
      @included_recipes << i
    end
    Chef::RunContext.any_instance.stub(:loaded_recipes).and_return(
      @included_recipes)

    # Drop extraneous writes to stdout
    Chef::Formatters::Doc.any_instance.stub(:library_load_start)
  end

  c.after(:suite) { FileUtils.rm_r(COOKBOOK_PATH) }
end

at_exit { ChefSpec::Coverage.report! }

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
