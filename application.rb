require "bundler"
Bundler.require

class Application < Sinatra::Base
  def initialize
    file = File.read('tarot.json')
    json = JSON.parse(file, symbolize_names: true)
    @cards = json[:cards]
    @suits = json[:suits]
    super
  end

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
    @cards.to_json
  end

  # return all cards
  get '/cards' do
    @cards.to_json
  end

  # return card by suit and rank
  get '/cards/:suit/:rank' do
    rank = params[:rank].downcase # ranks can be strings or ints
    suit = params[:suit].downcase

    card = @cards.detect { |card| card[:rank].to_s == rank && card[:suit] == suit }
    return halt_with_404_not_found unless card
    card.to_json
  end

  # return all suits
  get '/suits' do
    @suits.to_json
  end

  # return the details of a given suit
  get '/suits/:suit' do
    suit = params[:suit].downcase

    suit = @suits.detect { |s| s[:name].downcase == suit }

    return halt_with_404_not_found unless suit
    suit.to_json
  end

  # return all cards of a suit
  get '/suits/:suit/cards' do
    suit = params[:suit].downcase

    cards = @cards.select { |card| card[:suit] == suit }
    return halt_with_404_not_found unless cards.any?
    cards.to_json
  end

  # returns n cards
  get '/draw/:n' do
    n = params[:n].to_i

    halt 403, { message: "must be 0 or greater" }.to_json if n < 0
    @cards.sample(n).to_json
  end

  # find by name
  get '/find/:name' do
    replacements = {
      "2" => "two",
      "3" => "three",
      "4" => "four",
      "5" => "five",
      "6" => "six",
      "7" => "seven",
      "8" => "eight",
      "9" => "nine",
      "10" => "ten",
      "1" => "ace"
    }

    name = params[:name].gsub(/\d+/, replacements)

    card = @cards.detect { |card| card[:name].downcase == name.downcase }
    return halt_with_404_not_found unless card
    card.to_json
  end
end
