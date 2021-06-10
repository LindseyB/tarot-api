require "#{File.dirname(__FILE__)}/../spec_helper"

describe 'user controller' do
    include Rack::Test::Methods

    def app
        Sinatra::Application.new
    end

    specify 'return not found if user doesn\'t exist' do
        get '/users/3'
        last_response.should be_not_found
    end

    specify 'return an user' do
        User.create!(:id => 3, :name => "Test", :password => "toto", :email => "toto@toto.com")
        get '/users/3'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep["id"].should == 3
        rep["secret"].should == nil
    end

    specify 'list users' do
        User.create!(:id => 1, :name => "Test1", :password => "toto", :email => "toto1@toto.com")
        User.create!(:id => 2, :name => "Test2", :password => "toto", :email => "toto2@toto.com")
        User.create!(:id => 3, :name => "Test3", :password => "toto", :email => "toto3@toto.com")
        get '/users'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep.length.should == 3
        rep[0]["id"].should == 1
    end

    specify 'search users' do
        User.create!(:id => 1, :name => "Hector Dor", :password => "toto", :email => "toto1@toto.com")
        User.create!(:id => 2, :name => "Hector Dig", :password => "toto", :email => "toto2@toto.com")
        User.create!(:id => 3, :name => "John Doe", :password => "toto", :email => "toto3@toto.com")
        get '/users/search?q=Hector'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep.length.should == 2        
        rep[0]["id"].should == 1
    end

    specify 'create an user' do
        user = {"email" => "hector@troie.com", "password" => "helene", "name" => "hector"}
        put '/users', user.to_json, {"CONTENT_TYPE" => "application/json"}
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep["email"].should == "hector@troie.com"
        user = User.get(rep["id"])
        user.name.should == "hector"
    end

    specify 'create an invalid user' do
        user = {"password" => "helene", "name" => "hector"}
        put '/users', user.to_json, {"CONTENT_TYPE" => "application/json"}
        last_response.should be_bad_request
    end

    specify 'attach a resume to an user' do
        User.create!(:id => 3, :name => "Test", :password => "toto", :email => "toto@toto.com")
        filename = "#{File.dirname(__FILE__)}/../fixtures/ruby-resume.txt"
        file = Rack::Test::UploadedFile.new(filename, "text/txt")
        post "/users/3/resume", {:resume => file}
        last_response.should be_ok
    end
end

