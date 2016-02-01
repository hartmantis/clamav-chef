# Encoding: UTF-8

source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'rubocop'
  gem 'foodcritic', '~> 6.0'
  gem 'rspec'
  gem 'chefspec'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-docker'
end

group :integration do
  gem 'serverspec'
  gem 'cucumber'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'chef', '>= 11'
  gem 'berkshelf'
end
