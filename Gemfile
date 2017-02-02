# Encoding: UTF-8

source 'https://rubygems.org'

group :test do
  gem 'chefspec'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'foodcritic', '~> 6.0'
  gem 'kitchen-docker'
  gem 'kitchen-vagrant'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'test-kitchen'
end

group :integration do
  gem 'cucumber'
  gem 'serverspec'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'berkshelf'
  gem 'chef', '>= 11'
end
