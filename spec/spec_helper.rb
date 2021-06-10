# spec/spec_helper.rb
require "rack/test"
require "rspec"

ENV["RACK_ENV"] = "test"

require File.expand_path "../../application.rb", __FILE__

RSpec.configure do |config|
  config.include Rack::Test::Methods
end