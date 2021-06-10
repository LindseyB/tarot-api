require "#{File.dirname(__FILE__)}/../spec_helper"
require 'json'

describe 'user' do
    before(:each) do
        @user = User.new(:name => 'test user', :email => "toto@toto.com", :password => "toto")
        @user.save!
    end

    specify 'should be valid' do
        @user.should be_valid
    end

    specify 'should require a name' do
        user = User.new
        user.should_not be_valid
        user.errors[:name].should include("Name must not be blank")
    end

    specify 'should require a valid email' do
        @user = User.new(:name => 'test user', :email => "toto", :password => "toto")
        @user.should_not be_valid
        @user.errors[:email].should include("Email has an invalid format")
    end

    specify 'should support to_json export' do
        JSON.parse(@user.to_json).should == {"id"=>1, "name"=>"test user", "email"=>"toto@toto.com"}
    end
end
