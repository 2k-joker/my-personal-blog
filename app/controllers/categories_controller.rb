class CategoriesController < ApplicationController
  before_action :require_admin , except: [:index, :show]
  def create
    @category = Category.new(whitelist_category_params)
    if @category.save
      flash[:notice] = 'Category successfully created'
      redirect_to @category
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def index 
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end
  
  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  def search
    if params[:category].present?
      @categories = Category.search(params[:category])
      if @categories.any?
        respond_to do |format|
          format.js { render partial: 'categories/category_search_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No results found"
          format.js { render partial: 'categories/category_search_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Searching is not that hard. A single character is all it takes."
        format.js { render partial: 'categories/category_search_result' }
      end      
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(whitelist_category_params)
      flash[:notice] = "Category was successfully updated"
      redirect_to category_path(@category.id)
    else
      render 'edit'
    end
  end

  private

  def whitelist_category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      flash[:alert] = "Slow your role, admins only"
      redirect_to categories_path
    end
  end
end