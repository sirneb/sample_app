class UsersController < ApplicationController

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

end

