source "https://rubygems.org"

ruby "~> 2.7.0"

gem 'sinatra'

group :development do
  gem 'rake'
  gem 'pry'
end

if RUBY_PLATFORM.match?(/win32/)
  gem "eventmachine", "~> 1.0.0.beta.4.1"
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end
