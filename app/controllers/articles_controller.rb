class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]

  def create
    @article = Article.new(whitelist_article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = "Article was saved successfully"
      redirect_to article_path(@article.id)
    else
      render 'new'
    end    
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  def edit
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 3)  
  end

  def new
    @article = Article.new
  end

  def show
  end

  def update
    if @article.update(whitelist_article_params)
      flash[:notice] = "Article was successfully updated"
      redirect_to article_path(@article.id)
    else
      render 'edit'
    end
  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def whitelist_article_params
    params.require(:article).permit(:title, :description)
  end
end