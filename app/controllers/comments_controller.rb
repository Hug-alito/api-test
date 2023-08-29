class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments
    render json: @comments
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.user == current_user && @comment.update(comment_params)
      render json: @comment
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end