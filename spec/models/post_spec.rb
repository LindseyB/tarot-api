require "#{File.dirname(__FILE__)}/../spec_helper"
require 'json'

describe 'post' do
    before(:each) do
        @user = User.create!(:id => 1, :name => "Test1", :password => "toto", :email => "toto1@toto.com")
        @post = Post.new(:title => 'test post', :text => "Hello world", :user => @user)
        @post.save!
    end

    specify 'should be valid' do
        @post.should be_valid
    end

    specify 'should require a title' do
        post = Post.new
        post.should_not be_valid
        post.errors[:title].should include("Title must not be blank")
    end

    specify 'should support to_json export' do
        JSON.parse(@post.to_json).should == {"id"=>1, "text"=>"Hello world", "title"=>"test post", "user" => {"id"=>1, "name"=>"Test1", "email"=>"toto1@toto.com"}}
    end
end
