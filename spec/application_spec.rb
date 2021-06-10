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
    end

    it "is case insensitive" do
      get "/cards/sWoRdS/QuEeN"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "queen of swords"
      expect(card["suit"]).to eq "swords"
      expect(card["rank"]).to eq "queen"
    end

    it "replaces pentacles with coins" do
      get "/cards/pentacles/10"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "ten of coins"
      expect(card["suit"]).to eq "coins"
      expect(card["rank"]).to eq 10
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
    end

    it "is case insensitive" do
      get "/find/thE%20magician"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "The Magician"
      expect(card["suit"]).to eq "major"
      expect(card["rank"]).to eq 1
    end

    it "replaces pentacles with coins" do
      get "/find/ten%20of%20pentacles"
      expect(last_response).to be_ok

      card = JSON.parse(last_response.body)
      expect(card["name"]).to eq "ten of coins"
      expect(card["suit"]).to eq "coins"
      expect(card["rank"]).to eq 10
    end

    it "returns 404 if card not found" do
      get "/find/dash"
      expect(last_response).to be_not_found
    end
  end
end
