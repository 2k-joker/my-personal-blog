class ArticlesController < ApplicationController
  def create
    @article = Article.new(params.require(:article).permit(:title, :description))
    if @article.save
      flash[:notice] = "Article was saved successfully"
      redirect_to article_path(@article.id)
    else
      render 'new'
    end    
  end

  def edit
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all  
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(params.require(:article).permit(:title, :description))
      flash[:notice] = "Article was successfully updated"
      redirect_to article_path(@article.id)
    else
      render 'edit'
    end
  end
end