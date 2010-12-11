require 'spec_helper'

describe "Users" do
  
  describe "Sign up" do
    
     describe "Unsuccessful sign in" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)      
      end
    end
    
    describe "Successful sign in" do
    
      it "should make a user and store it in the database" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"   
          click_button
          response.should render_template('users/new')
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    
    describe "unsuccessful sign in" do
      it "should not sign the user in" do
        visit signin_path
        fill_in "Email",          :with => ""
        fill_in "Password",       :with => ""
        click_button
        response.should render_template('sessions')
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
    
    describe "successful sign in" do
      it "should sign a user in" do
        user = Factory(:user)
        visit signin_path
        fill_in "Email",         :with => user.email
        fill_in "Password",      :with => user.password
        click_button
        response.should render_template('users/show')
        controller.should be_signed_in
        response.should_not have_selector("div.flash.error", :content => "Invalid")
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end














