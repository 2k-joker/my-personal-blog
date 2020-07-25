class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]

  def create
    @user = User.new(whitelist_user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Sign up successful. Welcome aboard #{@user.username}!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
    
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end
  
  def new
    @user = User.new
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 10)
  end

  def update
    if @user.update(whitelist_user_params)
      flash[:notice] = "Account successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
    
  end
  
  private

  def whitelist_user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
