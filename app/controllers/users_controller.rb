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

  def new
    @user = User.new
  end

  private

  def whitelist_user_params
    params.require(:user).permit(:username, :email, :password)
  end  
end
