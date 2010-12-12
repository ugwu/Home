require 'spec_helper'
require 'pp'


describe "User Model. Name and E-mail validation" do
  
  before(:each) do
     @attr = {:name => "Example User", 
               :email => "user@example.com", 
               :password => "12345A", 
               :password_confirmation => "12345A" }
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

describe "User Model. Passsword and Password confirmation validation" do
  
  before(:each) do
    @attr = {:name => "Example User", 
             :email => "user@example.com", 
             :password => "12345A", 
             :password_confirmation => "12345A" }
  end
  
  it "should accept a valid user entry request" do
    user = User.create!(@attr)
    user.should be_valid
  end
  
  it "should validate the presence of a password and the password confirmation" do
    user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
    user.should_not be_valid
  end
  
  it "should validate the presence of a password" do
    user = User.new(@attr.merge(:password => "", :password_confirmation => "12345A"))
    user.should_not be_valid
  end
  
  it "should validate the presence of a password confirmation" do
     user = User.new(@attr.merge(:password => "12345A", :password_confirmation => ""))
     user.should_not be_valid
  end
  
  it "should require a matching password confirmation" do
    User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
  end
  
  it "should reject invalid passwords" do
    password = [('a' *41), ('a' *5)]
    
    password.each do |pass| 
      user = User.new(@attr.merge(:password => pass, :password_confirmation => pass))
      user.should_not be_valid
    end
  end


  describe "Password Encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
  
    it "it should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
   
    describe "has password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    
      
      
      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
      describe "Authenticate functionality" do
        it "should return nil on email/password match" do
          user = User.authenticate(@attr[:email], "wrong_password")
          user.should be_nil
        end
        
        it "should return nil on email with no user" do
          user = User.authenticate("bar@foo.com", @attr[:password])
          user.should be_nil
        end
        
        it "should return true for email and password match" do
          user = User.authenticate(@attr[:email], @attr[:password])
          user.should == @user
        end
      end
  end
  
  describe "admin attribute" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should response to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
end
  

 













