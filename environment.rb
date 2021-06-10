require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'

require 'sinatra' unless defined?(Sinatra)
APP_ROOT = File.dirname(__FILE__)

configure do
    # load models
    $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib/models")
    Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb") { |lib| require File.basename(lib, '.*') }
    DataMapper.finalize
    DataMapper.setup(:default, "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db")

end

