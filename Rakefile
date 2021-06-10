require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'

task default: %w[server]

task :server do
  sh "rackup --host 0.0.0.0"
end

task :test do
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task["spec"].execute
end