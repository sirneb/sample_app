class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,    :only => :destroy

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    # disallow create when signed in

    if signed_in?
      redirect_to(root_path)
    else
      @title = "Sign up"
      @user = User.new
    end
  end

  def create
    # disallow create when signed in
    if signed_in?
      redirect_to(root_path)
    else
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
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def destroy
    if current_user == User.find(params[:id])
      flash[:error] = "Cannot delete thyself, Romeo!"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end

    redirect_to users_path

  end

  private 
  
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin? 
    end

end

