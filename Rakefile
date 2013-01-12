#!/usr/bin/env rake

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), "/tmp/foodcritic/cookbooks")
    cookbooks = File.join(File.dirname(__FILE__), "/cookbooks")
    sh "foodcritic --epic-fail any #{cookbooks}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2"
  end
end

task :default => "foodcritic"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
