require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require "sinatra/base"
require 'json'

require File.join(File.dirname(__FILE__), 'environment')


#The helper json should use the default to_json method
set :json_encoder, :to_json

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  def error code, data
    data = {:errors => data}
    halt code, {'Content-Type' => 'application/json'}, data.to_json
  end

  def cards
    # At first I was like meh put this into a db and then I was like you know what
    # fuck it, file IO like this, fast enough
    file = File.read('./tarot_interpretations.json')
    data_hash = JSON.parse(file)

    return data_hash["tarot_interpretations"]
  end
end

# return all cards
get '/' do
  json cards
end

# return all cards
get '/cards' do
  json cards
end

# return card by id
get '/cards/:id' do
  id = params[:id]

  json cards.detect { |card| card["rank"] == id }
end

# returns n cards
get '/cards/:n/draw' do
  n = params[:n]

  json cards.sample(n)
end

# find by name
get '/find/:name' do
  name = params[:name]

  json cards.detect { |card| card["name"] == name }
end