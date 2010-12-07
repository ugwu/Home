require 'spec_helper'
require 'pp'

describe User do
  
  before(:each) do
    @attr = {:name => "Example User", :email => "user@example.com"}
  end
  
  it "should create a new instance given valid attributes" do     
    user = User.create!(@attr)
    user.should be_valid
  end
    
  it "should validate the presence of a name" do
    no_name = User.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end
  
  it "should validate the presence of an email address" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end
  
  it "should validate that the name field is at max 50 characters" do
    long = 'a' * 51
    long_name = User.new(@attr.merge(:name => long))
    long_name.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email = User.new(@attr.merge(:email => address))
      valid_email.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email = User.new(@attr.merge(:email => address))
      invalid_email.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
     user_1 = User.create!(@attr)
     duplicate_user = User.new(@attr)
     duplicate_user.should_not be_valid    
   end
     
  it "should reject email addresses identical up to case" do
     User.create!(@attr)
     duplicate_user = User.new(@attr[:email].upcase)
     duplicate_user.should_not be_valid
  end    
  
end


















