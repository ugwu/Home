require 'pp'
class UsersController < ApplicationController
  
  def create
    @user = User.new(params[:user])       
      if @user.save
        flash[:success] = "Welcome to the Sample App!"         
         redirect_to @user
         sign_in(@user)
      else
        @title = "Sign up"
        @user.password = nil
        @user.password_confirmation = nil 
        render ('new')
       
       # Add code to ensure the password field is cleared on failed submissions.
      end
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
end
