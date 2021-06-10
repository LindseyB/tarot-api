require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
    include Rack::Test::Methods

    def app
        Sinatra::Application.new
    end

    specify 'should show the default index page' do
        get '/'
        last_response.should be_ok
    end

    specify 'should throw 401 if no credentials for /me' do
        get '/me'
        last_response.status.should == 401
    end

    specify 'should throw 401 if invalid name & password for /me' do
        User.create(:email => "jd@usvn.fr", :password => "toto", :name => "julien")
        authorize 'bad', 'boy'
        get '/me'
        last_response.status.should == 401
    end

    specify 'should throw 401 if invalid password for /me' do
        User.create(:email => "jd@usvn.fr", :password => "toto", :name => "julien")
        authorize 'jd@usvn.fr', 'boy'
        get '/me'
        last_response.status.should == 401
    end

    specify 'should throw 200 if valid credentials for /me' do
        User.create(:email => "jd@usvn.fr", :password => "toto", :name => "julien", :secret => "dog")
        authorize 'jd@usvn.fr', 'toto'
        get '/me'
        last_response.status.should == 200
        rep = JSON.parse(last_response.body)
        rep["name"].should == "julien"
        rep["secret"].should == "dog"
    end
end
