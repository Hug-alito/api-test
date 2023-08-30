class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authorize_user!, only: [:update, :destroy, :edit]

  # GET /articles
  def index
    if current_user
      @articles = Article.where('user_id = ? OR private = ?', current_user.id, false)
    else
      @articles = Article.where(private: false)
    end

    render json: @articles
  end

  # GET /articles/1
  def show
    if @article.private && @article.user != current_user
      render json: { error: "Vous n'avez pas accès à cet article." }, status: :forbidden
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.user == current_user && @article.update(article_params)
      render json: @article
    else
      render json: { error: "Vous n'avez pas la permission de modifier cet article." }, status: :forbidden
    end
  end

  # DELETE /articles/1
  def destroy
    if @article.user == current_user
      @article.destroy
      render json: { message: "L'article a été supprimé avec succès." }
    else
      render json: { error: "Vous n'avez pas la permission de supprimer cet article." }, status: :forbidden
    end
  end

  def make_private
    @article = Article.find(params[:id])
    @article.update(private: true)
    render json: @article
  end

  def make_public
    @article = Article.find(params[:id])
    @article.update(private: false)
    render json: @article
  end

  def comments
    @article = Article.find(params[:id])
    @comments = @article.comments
    render json: @comments
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :private)
    end
    
    def authorize_user!
      unless @article.user == current_user
        render json: { error: "Vous n'avez pas la permission d'effectuer cette action." }, status: :forbidden
      end
    end
end