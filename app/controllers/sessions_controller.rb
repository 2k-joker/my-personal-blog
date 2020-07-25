class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'Login successful'
      redirect_to user
    else
      flash.now[:alert] = 'Invalid login credentials'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to root_path
  end
  
  def new
  end
end