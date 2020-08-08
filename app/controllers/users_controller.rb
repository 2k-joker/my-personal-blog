class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :destroy]
  before_action :require_user_auth, only: [:update, :edit]
  before_action :verify_user, only: [:edit, :update, :destroy]

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

  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "Account successfully deleted"
    redirect_to root_path
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

  def search
    if params[:user].present?
      @users = User.search(params[:user])
      if logged_in?
        @users = current_user.except_current_user(@users)
      end
      if @users.any?
        respond_to do |format|
          format.js { render partial: 'users/user_search_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No results found"
          format.js { render partial: 'users/user_search_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Searching is not that hard. A single character is all it takes."
        format.js { render partial: 'users/user_search_result' }
      end      
    end
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

  def set_user
    @user = User.find(params[:id])
  end

  def verify_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "Access denied. Stop trying to reap where you did not sow"
      redirect_to @user
    end
  end


  def whitelist_user_params
    params.require(:user).permit(:username, :email, :password, :first_name, :last_name)
  end  
end
