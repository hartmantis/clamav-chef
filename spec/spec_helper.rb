# Encoding: UTF-8

require 'chef'
require 'chefspec'
require 'tmpdir'
require 'fileutils'
require 'simplecov'
require 'simplecov-console'
require 'coveralls'
require 'support/resources/apt_repository'
require 'support/resources/cron_d'
require 'support/resources/logrotate_app'
require 'support/matchers/apt_repository'
require 'support/matchers/cron_d'
require 'support/matchers/logrotate_app'

def stub_apt_resources
  allow_any_instance_of(Chef::ResourceCollection).to receive(:find)
    .with('execute[apt-get update]')
    .and_return(Chef::Resource::Execute.new('apt-get update'))
end

def stub_service_resources
  %w(clamd clamav-daemon freshclam clamav-freshclam).each do |s|
    allow_any_instance_of(Chef::ResourceCollection).to receive(:find)
      .with("service[#{s}]")
      .and_return(Chef::Resource::Service.new(s))
  end
end

RSpec.configure do |c|
  c.color = true

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
    allow_any_instance_of(Chef::Cookbook::Metadata).to receive(:depends)

    # Prep lookup() for the stubs below
    allow_any_instance_of(Chef::ResourceCollection).to receive(:find)
      .and_call_original

    # Test each recipe in isolation, regardless of includes
    @included_recipes = []
    allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?)
      .and_return(false)
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe) do |_, i|
      # Recipes that define scripts or services are a special case
      case i
      when 'apt'
        stub_apt_resources
      when 'clamav::services'
        stub_service_resources
      end
      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?)
        .with(i).and_return(true)
      @included_recipes << i
    end
    allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipes)
      .and_return(@included_recipes)
  end

  c.after(:suite) { FileUtils.rm_r(COOKBOOK_PATH) }
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)
SimpleCov.minimum_coverage(90)
SimpleCov.start

at_exit { ChefSpec::Coverage.report! }
