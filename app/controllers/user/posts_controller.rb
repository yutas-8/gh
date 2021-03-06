class User::PostsController < ApplicationController
  before_action :authenticate_member!
  before_action :correct_member, only: [:edit, :update]
  def index
    @posts = Post.page(params[:page]).reverse_order
  end

  def show
    @posts = Post.page(params[:page]).reverse_order
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.member_id = current_member.id
    if @post.save
      redirect_to post_path(@post.id), notice: "投稿成功しました。"
    else
      flash.now[:alert] = "投稿失敗しました。"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "更新しました。"
    else
      flash.now[:alert] = "更新失敗しました。"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, notice: "削除しました。"
    else
      flash.now[:alert] = "削除失敗しました。"
      render :index
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

    def correct_member
      @post = Post.find(params[:id])
      redirect_to posts_path unless @post.member == current_member
    end
end
