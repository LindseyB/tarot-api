require "bundler"
Bundler.require

require_relative "cards"

class Application < Sinatra::Base
  configure do
    disable :protection
  end

  helpers do
    def halt_with_404_not_found
      halt 404, { message: "Not found" }.to_json
    end
  end

  before do
    content_type :json
  end

  # return all cards
  get '/' do
    CARDS.to_json
  end

  # return all cards
  get '/cards' do
    CARDS.to_json
  end

  # return card by suit and rank
  get '/cards/:suit/:rank' do
    suit = params[:suit].downcase.gsub("pentacles", "coins")
    rank = params[:rank].downcase # ranks can be strings or ints

    card = CARDS.detect { |card| card[:rank].to_s == rank && card[:suit] == suit }
    return halt_with_404_not_found unless card
    card.to_json
  end

  # returns n cards
  get '/draw/:n' do
    n = params[:n].to_i

    halt 403, { message: "must be 0 or greater" }.to_json if n < 0
    CARDS.sample(n).to_json
  end

  # find by name
  get '/find/:name' do
    # uses coins not pentacles
    name = params[:name].downcase.gsub("pentacles", "coins")

    card = CARDS.detect { |card| card[:name].downcase == name }
    return halt_with_404_not_found unless card
    card.to_json
  end
end
