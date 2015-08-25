class PostsController < ApplicationController

  def create
      uid =  (user_signed_in?) ? current_user.id : 0
      college_id = College.find_by_name(params[:college_name]).try(:id)
  	  post = Post.create(user_id: uid, text: params[:post][:text], college_id: college_id, 
        school_specific: ( params[:post][:school_specific].to_i == 1 ), votes_up: 0, votes_down: 0, approved: false)

      redirect_to post
  end

  def destroy
  end

  def index
    gon.post_params = {
      approved: true,
      order: 'created_at DESC'
    }
    gon.post_params[:specific] = college_specific if user_signed_in?
  end

  def vote
    gon.post_params = {
      approved: false,
      order: 'created_at DESC'
    }
    gon.post_params[:specific] = college_specific if user_signed_in?
  end

  def search
    # search_term = params[:q]
    gon.post_params = {
      approved: true,
      order: 'created_at DESC',
    }
    gon.post_params[:specific] = college_specific if user_signed_in?
    #@posts = Post.includes(:user).where( ["SELECT * FROM posts WHERE text % ?", search_term] )
  end

  def bestof
    if params[:limit] == 'week'
      time_limit = 1.week.ago
    elsif params[:limit] == 'month'
      time_limit = 1.month.ago
    else
      time_limit = 50.years.ago   # best of all time
    end

    gon.post_params = {
      approved: true,
      order: 'votes_up - votes_down DESC',
      limit: time_limit
    }
    gon.post_params[:specific] = college_specific if user_signed_in?
  end

  def show
    @posts = Post.with_associated.where(id: params[:id].to_i)
    @comments_allowed = (@posts.size == 1 && @posts.first.approved)
    @removed = @posts.size < 1
  end


  def post_loader
    @posts = find_posts


    if(@posts.size > 0)
      respond_to do |format|
        format.html {render partial: 'post_loader'}
      end
    else
      render nothing: true
    end
  end


  def vote_up
    Post.increment_counter(:votes_up, params[:pid].to_i)
    render nothing: true
  end

  def vote_down
    Post.increment_counter(:votes_down, params[:pid].to_i)
    render nothing: true
  end



private

  def college_specific
    current_user.college.try(:name) || false
  end
# all posts sorted on either:
  # approved (true for: main, school, bestof, search;  false for: vote, user)
  # school_specific (true for: main, vote, bestof; false for: school, user, search) -- user must be signed in
  # user (string - only for user)
  # school (string - only for school)
  # q (string - only for search)
  def find_posts
    per_page = 15
    page_num = params[:page_num].to_i
    page_num = page_num < 1 ? 1 : page_num

    # multiple assignments of @posts essentially works as chaining .where() since .where() is not immediately evaluated/queried
    @posts = Post.all.with_associated # all posts
    @posts = @posts.where( school_specific: false ) unless user_signed_in? and params.has_key?(:specific) and params[:specific] == current_user.try(:college).try(:name)
    @posts = @posts.where( approved: params[:approved] ) if params.has_key?(:approved) # for main page: approved=true; vote page: approved=false
    @posts = @posts.where( ["posts.created_at > ? AND approved = TRUE", params[:limit] ] ) if params.has_key? :limit # for bestof page
    @posts = @posts.where( user_id: params[:uid] ) if params.has_key? :uid # for user pages
    @posts = @posts.where('colleges.name = ?', params[:school]) if params.has_key? :school # for school pages
    
    #@posts = @posts.where( [ "SELECT * FROM posts WHERE text % ?", params[:q] ] ) if params.has_key?(:q) # search page
    
    @posts = @posts.offset( (page_num-1) * per_page )
    @posts = @posts.limit(per_page)
    @posts = @posts.order( params[:order] ) if params.has_key?(:order)

    return @posts
  end

end