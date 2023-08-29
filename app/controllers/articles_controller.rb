class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authorize_user!, only: [:destroy, :edit]

  # GET /articles
  def index
    @articles = Article.all

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: @article
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
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
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
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content)
    end
    
    def authorize_user!
      unless @article.user == current_user
        flash[:alert] = "Vous n'avez pas la permission d'accéder à cette page."
        redirect_to root_path
      end
    end
end