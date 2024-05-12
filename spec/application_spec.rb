require "spec_helper"

describe 'Application' do
  def app
    Application
  end

  describe "/" do
    it "should return all cards" do
      get "/"
      expect(last_response).to be_ok

      expect(last_response.body).to include("The Magician")
      expect(JSON.parse(last_response.body).length).to eq 78
    end
  end

  describe "/cards" do
    it "should return all cards" do
      get "/cards"
      expect(last_response).to be_ok

      expect(last_response.body).to include("The Magician")
      expect(JSON.parse(last_response.body).length).to eq 78
    end
  end

  describe "/cards/:suit/:rank" do
    it "returns the specified card" do
      get "/cards/major/1"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "The Magician"
      expect(card["suit"]).to eq "major"
      expect(card["rank"]).to eq 1
      expect(card["image_path"]).to eq "/cards/TheMagician.png"
    end

    it "returns the correct image path for a card that needs to be 0 padded" do
      get "/cards/swords/9"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "Nine of Swords"
      expect(card["suit"]).to eq "swords"
      expect(card["rank"]).to eq 9
      expect(card["image_path"]).to eq "/cards/Swords09.png"
    end

    it "is case insensitive" do
      get "/cards/sWoRdS/QuEeN"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "Queen of Swords"
      expect(card["suit"]).to eq "swords"
      expect(card["rank"]).to eq "queen"
      expect(card["image_path"]).to eq "/cards/Swords13.png"
    end

    it "returns a 404 if card not found" do
      get "/cards/cats/dash"
      expect(last_response).to be_not_found
    end
  end

  describe "/draw/:n" do
    it "returns the number of requested cards" do
      get "/draw/3"
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body).length).to eq 3
    end

    it "returns an error if negative cards requested" do
      get "/draw/-1"
      expect(last_response).to be_forbidden
    end
  end

  describe "/find/:name" do
    it "returns the specified card" do
      get "/find/The%20Magician"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "The Magician"
      expect(card["suit"]).to eq "major"
      expect(card["rank"]).to eq 1
      expect(card["image_path"]).to eq "/cards/TheMagician.png"
    end

    it "is case insensitive" do
      get "/find/thE%20magician"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "The Magician"
      expect(card["suit"]).to eq "major"
      expect(card["rank"]).to eq 1
      expect(card["image_path"]).to eq "/cards/TheMagician.png"
    end

    it "replaces numbers with words" do
      get "/find/10%20of%20swords"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "Ten of Swords"
      expect(card["suit"]).to eq "swords"
      expect(card["rank"]).to eq 10
      expect(card["image_path"]).to eq "/cards/Swords10.png"
    end

    it "returns 404 if card not found" do
      get "/find/dash"
      expect(last_response).to be_not_found
    end
  end

  describe "/suits" do
    it "returns all suits" do
      get "/suits"
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body).length).to eq 4
    end
  end

  describe "/suits/:suit/cards" do
    it "returns all cards for a valid suit" do
      get "/suits/cups/cards"
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body).length).to eq 14
    end

    it "works for major arcana" do
      get "/suits/major/cards"
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body).length).to eq 22
    end

    it "is case insensitive" do
      get "/suits/SwOrDs/cards"
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body).length).to eq 14
    end

    it "returns 404 if suit not found" do
      get "/suits/dash/cards"

      expect(last_response).to be_not_found
    end
  end

  describe "/suits/:suit" do
    it "returns the specified suit" do
      get "/suits/cups"
      expect(last_response).to be_ok

      suit = JSON.parse(last_response.body)
      expect(suit["name"]).to eq "cups"
      expect(suit["element"]).to eq "water"
    end

    it "is case insensitive" do
      get "/suits/SwOrDs"
      expect(last_response).to be_ok

      suit = JSON.parse(last_response.body)
      expect(suit["name"]).to eq "swords"
      expect(suit["element"]).to eq "air"
    end

    it "returns 404 if suit not found" do
      get "/suits/dash"

      expect(last_response).to be_not_found
    end
  end
end
