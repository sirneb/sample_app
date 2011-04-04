class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      # reset the password field
      @user.password = ""
      @user.password_confirmation = ""
      
      
      # redirects back
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      
      # reset the password field
      @user.password = ""
      @user.password_confirmation = ""
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  private 
  
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end

