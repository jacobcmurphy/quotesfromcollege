class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    uid =  (user_signed_in?) ? current_user.id : 0
    college_id = College.find_by(name: params[:college_name]).try(:id)
    @post = Post.new(user_id: uid, text: params[:post][:text], college_id: college_id, 
      school_specific: ( params[:post][:school_specific].to_i == 1 ), votes_up: 0, votes_down: 0, approved: false)

    if @post.save
      flash[:notice] = "<b>Share this with your friends!</b><br />Click an icon at the bottom right of your post".html_safe
      redirect_to @post
    else
      render :new
    end
  end

  def destroy
  end

  def index
    @posts = Post.visible_to_user(current_user).where(approved: true).page(params[:page]).order('updated_at DESC')
  end

  def vote
    @posts = Post.visible_to_user(current_user).where(approved: false).page(params[:page]).order('updated_at DESC')

    render :index
  end

  def bestof
    if params[:limit] == 'week'
      date_limit = 1.week.ago
    elsif params[:limit] == 'month'
      date_limit = 1.month.ago
    else
      date_limit = 50.years.ago   # best of all time
    end

    @posts = Post.visible_to_user(current_user).where(['approved = true AND posts.created_at > ?', date_limit]).order('votes_up - votes_down DESC').page(params[:page])

    render :index
  end

  def show
    @post = Post.find(params[:id])
    @comments_allowed = @post.approved
  end

  def vote_up
    Post.increment_counter(:votes_up, params[:pid].to_i)
    render nothing: true
  end

  def vote_down
    Post.increment_counter(:votes_down, params[:pid].to_i)
    render nothing: true
  end
end
