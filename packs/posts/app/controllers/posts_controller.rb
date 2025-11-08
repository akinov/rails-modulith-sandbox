class PostsController < ApplicationController
  # GET /posts
  def index
    posts = Post.all
    render json: posts
  end

  # GET /posts/:id
  def show
    post = Post.find(params[:id])
    render json: post
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  # POST /posts
  def create
    post = Post.new(post_params)

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:text)
  end
end

