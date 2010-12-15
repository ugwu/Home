require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @base_line = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new                       # the same as get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => @base_line + " | Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']") 
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
    
  end
  
  describe "GET 'Show'" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end 
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user 
      assigns(:user).should == @user
    end
    
    it "should have the correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the user's name " do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
    
    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
    
  end      
  
  
  describe "Sign in POST Create" do
    
    describe "Invalid post requests" do
      before(:each) do
        @attr = {:name => "", 
                 :email => "", 
                 :password => "", 
                 :password_confirmation => "" }
      
      end
    
      it "should not create a user" do
          lambda do
             post :create, :user => @attr
           end.should change(User, :count).by(0)
       end
     
     it "should have the right title" do
       post :create, :user => @attr
       response.should have_selector("title", :content => "Sign up")
     end
     
     it "should render the 'new' page" do
       post :create, :user => @attr
       response.should render_template('new')
     end
    end
      
      describe "Successful sign up" do
        
        before(:each) do
          @attr = { :name => "New User", :email => "user@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }
          
        end
        
        it "should create a user and save him in the database" do
          lambda do
            post(:create, :user => @attr)
          end.should change(User, :count).by(1)
        end
        
        it "should redirect the user to the correct page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end
        
        it "should have a welcome message" do
          post :create, :user => @attr
          flash[:success].should =~ /welcome to the sample app/i
        end
        
        it "should sign the user in upon sign up" do
          post :create, :user => @attr
          controller.should be_signed_in
        end
        
      end  
   end
   
   describe "PUT Request Editing a user" do
     
     before(:each) do
        @user = test_sign_in(Factory(:user))
     end
     
     it "should be successful" do
       get :edit, :id => @user
       response.should be_success
     end
     
     it "should have the right title" do
       get :edit, :id => @user
       response.should have_selector('title', :content => "Edit user")
     end
     
     it "should have a link to change the Gravatar" do
       get :edit, :id => @user
       gravatar_url = "http://gravatar.com/emails"
       response.should have_selector('a', :href => gravatar_url, :content => "change")
     end
   end
   
    describe "PUT 'update'" do
  
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
  
      describe "failure" do
  
        before(:each) do
          @attr = { :email => "", :name => "", :password => "",
                    :password_confirmation => "" }
        end
  
        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end
  
        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
      end
  
      describe "success" do
  
        before(:each) do
          @attr = { :name => "New Name", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
        end
  
        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should  == @attr[:name]
          @user.email.should == @attr[:email]
        end
  
        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end
  
        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
    
    describe "authentication of edit/update pages" do
      
      before(:each) do
        @user = Factory(:user)
      end
      
      describe "for non signed in users " do
        
        it "should deny any access to edit" do
          get :edit, :id => @user
          response.should_not be_success
          response.should redirect_to(signin_path)
        end
        
        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end
  
      describe "for signed in users" do
        
        before(:each) do
          wrong_user = Factory(:user, :email => "user@example.net")
          test_sign_in(wrong_user)
        end
        
        it "should require matching users for edit" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end
        
        it "should require matching users for 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
        
        it "should not allow users to access edit pages" do
          test_sign_out
          get :show, :id => @user
          response.should redirect_to(signin_path)
          response.should_not be_success
        end
      end
    end
    
  describe "GET index" do
    
    describe "for non-signed in users" do
    
      it "should deny access to the index page" do
        get :index
        response.should_not be_success
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed in users" do
      before(:each) do
        @user  = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
     
      
      it "should render the index page" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
         get :index
         @users[0..2].each do |user|
           response.should have_selector("li", :content => user.name)
         end
       end

       it "should paginate users" do
         get :index
         response.should have_selector("div.pagination")
         response.should have_selector("span.disabled", :content => "Previous")
         response.should have_selector("a", :href => "/users?page=2",
                                            :content => "2")
         response.should have_selector("a", :href => "/users?page=2",
                                                :content => "Next")
        end
      end
    end


  describe "Delete 'destory'" do
    
    before(:each) do
      @user = Factory(:user)
      @user_1 = Factory(:user, :email => "admin@example.net")
    end
      
    describe "as a non signed in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path) 
  
      end
    end
    
    describe "as a non admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      it "should delete the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
         delete :destroy, :id => @user
         response.should redirect_to(users_path)
      end
      
      it "should not allows admin users to delete themselves" do
        lambda do
          delete :destroy, :id => @admin
        end.should change(User, :count).by(0)
      flash[:notice].should =~ /Admin users cannot delete themselves/i 
      end
    end    
  end
  
  
  describe "follow pages" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @other_user = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@other_user)
    end

    describe "when not signed in" do
    
      it "should protect 'following'" do
        get :following, :id => @other_user
        response.should redirect_to(signin_path)
      end
    
      it "should protect 'followers'" do
        get :followers, :id => @other_user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "when signed in" do
    
      it "should show user following" do
        get :following, :id => @user
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end
    
      it "should show user followers" do
        get :followers, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end
  end
end
      




















