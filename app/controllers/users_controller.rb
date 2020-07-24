class UsersController < ApplicationController

  def create
    @user = User.new(whitelist_user_params)

    if @user.save
      flash[:notice] = "Sign up successful. Welcome aboard #{@user.username}!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if @user.update(whitelist_user_params)
      flash[:notice] = "Account successfully updated"
      redirect_to articles_path
    else
      render 'edit'
    end
    
  end
  
  private

  def whitelist_user_params
    params.require(:user).permit(:username, :email, :password)
  end  
end
