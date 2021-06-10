require "bundler"
Bundler.require


class Application < Sinatra::Base
  helpers do
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
    id = params[:id].to_i

    json cards.detect { |card| card["rank"] == id }
  end

  # returns n cards
  get '/cards/:n/draw' do
    n = params[:n].to_i

    json cards.sample(n)
  end

  # find by name
  get '/find/:name' do
    name = params[:name]

    json cards.detect { |card| card["name"] == name }
  end
end