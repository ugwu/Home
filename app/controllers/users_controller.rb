require 'pp'
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :show, :index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  # before_filter :authenticate, :except => [:new, :create]
  
  
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    if current_user.nil?
      redirect_to(signin_path)
    else      
      redirect_to(root_path) unless current_user.admin?
    end
  end
  
   
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
        render('new')
       
       # Add code to ensure the password field is cleared on failed submissions.
      end
  end
  
  def new
    if current_user == nil
      @title = "Sign up"
      @user = User.new
    else
      redirect_to(root_path)
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])  
  end
  
  def edit
    # @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render('edit')
    end
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])  
  end
  
  def destroy
    if User.find(params[:id]).admin?
      flash[:notice] = "Admin users cannot delete themselves."
      redirect_to users_path    
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end    
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  
  private :correct_user, :admin_user
end
