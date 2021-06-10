require "#{File.dirname(__FILE__)}/../spec_helper"

describe 'post controller' do
    include Rack::Test::Methods

    def app
        Sinatra::Application.new
    end

    before(:each) do
        @user = User.create(:name => "julien", :password => "toto", :email => "jd@usvn.fr")
    end

    specify 'return not found if post doesn\'t exist' do
        get '/posts/3'
        last_response.should be_not_found
    end

    specify 'return an post' do
        Post.create!(:id => 3, :title => "Test", :text => "Hello World", :user => @user)
        get '/posts/3'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep["id"].should == 3
        rep["secret"].should == nil
    end

    specify 'list posts' do
        Post.create!(:id => 1, :title => "Test 1", :text => "Hello World", :user => @user)
        Post.create!(:id => 2, :title => "Test 2", :text => "Hello World", :user => @user)
        Post.create!(:id => 3, :title => "Test 3", :text => "Hello World", :user => @user)
        get '/posts'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep.length.should == 3
        rep[0]["id"].should == 1
    end

    specify 'search posts' do
         Post.create!(:id => 1, :title => "Test 1", :text => "Hello World", :user => @user)
        Post.create!(:id => 2, :title => "Test 2", :text => "Hello World", :user => @user)
        Post.create!(:id => 3, :title => "False 3", :text => "Hello World", :user => @user)
        get '/posts/search?q=Test'
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep.length.should == 2        
        rep[0]["id"].should == 1
    end

    specify 'create a post' do
        authorize 'jd@usvn.fr', 'toto'
        post = {"title" => "Test", "text" => "Hello World"}
        put '/posts', post.to_json, {"CONTENT_TYPE" => "application/json"}
        last_response.should be_ok
        rep = JSON.parse(last_response.body)
        rep["text"].should == "Hello World"
        post = Post.get(rep["id"])
        post.title.should == "Test"
        post.user.should == @user
    end

    specify 'create an invalid post' do
        authorize 'jd@usvn.fr', 'toto'
        post = {}
        put '/posts', post.to_json, {"CONTENT_TYPE" => "application/json"}
        last_response.should be_bad_request
    end

    specify 'create a post withou auth' do
        post = {}
        put '/posts', post.to_json, {"CONTENT_TYPE" => "application/json"}
        last_response.status.should == 401
    end
end
