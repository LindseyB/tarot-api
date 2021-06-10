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

    def halt_with_404_not_found
      halt 404, json({ message: "Not found" })
    end

    def halt_with_403_forbidden_error(message = nil)
      message ||= "Forbidden"
      halt 403, json({ message: message })
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

  # return card by suit and rank
  get '/cards/:suit/:rank' do
    suit = params[:suit].downcase.gsub("pentacles", "coins")
    rank = params[:rank].downcase # ranks can be strings or ints

    card = cards.detect { |card| card["rank"].to_s == rank && card["suit"] == suit }
    halt_with_404_not_found unless card
    json card
  end

  # returns n cards
  get '/draw/:n' do
    n = params[:n].to_i

    halt_with_403_forbidden_error("must be 0 or greater") if n < 0
    json cards.sample(n)
  end

  # find by name
  get '/find/:name' do
    # uses coins not pentacles
    name = params[:name].downcase.gsub("pentacles", "coins")

    card = cards.detect { |card| card["name"].downcase == name }
    halt_with_404_not_found unless card
    json card
  end
end