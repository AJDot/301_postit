class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show, :vote]
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.limit(Post::PER_PAGE).offset(params[:offset])
    @pages = (Post.all.size / Post::PER_PAGE)
    @pages += 1 if (Post.all.size % Post::PER_PAGE != 0)
  end

  def show
    respond_to do |format|
      format.html do
        @comment = Comment.new
      end
      format.json do
        render json: @post, except: [:id, :user_id], include: { comments: { except: [:post_id, :user_id, :id] }, creator: { except: [:id, :password_digest, :role]}}
      end
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "This post was updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote on a post once."
        end

        redirect_to :back
      end

      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def require_creator
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
  end
end
