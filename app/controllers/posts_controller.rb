class PostsController < ApplicationController

  def create
      uid =  (user_signed_in?) ? current_user.id : 0
      college_id = College.find_by(name: params[:college_name]).try(:id)
  	  post = Post.create(user_id: uid, text: params[:post][:text], college_id: college_id, 
        school_specific: ( params[:post][:school_specific].to_i == 1 ), votes_up: 0, votes_down: 0, approved: false)

      redirect_to post
  end

  def destroy
  end

  def index
    session[:posts] = {approved: true}
  end

  def vote
    session[:posts] = {approved: false}
    render :index
  end

  def search
    # search_term = params[:q]
    gon.post_params = {
      approved: true,
      order: 'created_at DESC',
    }
    #@posts = Post.includes(:user).where( ["SELECT * FROM posts WHERE text % ?", search_term] )
    render :index
  end

  def bestof
    session[:posts] = { approved: true, order: 'votes_up - votes_down DESC'}
    if params[:limit] == 'week'
      session[:posts][:date_limit] = 1.week.ago
    elsif params[:limit] == 'month'
      session[:posts][:date_limit] = 1.month.ago
    else
      session[:posts][:date_limit] = 50.years.ago   # best of all time
    end

    render :index
  end

  def show
    @posts = Post.with_associated.where(id: params[:id])
    @comments_allowed = (@posts.size == 1 && @posts.first.approved)
    @removed = @posts.size < 1
  end


  def post_loader
    @posts = find_posts

    if @posts.present?
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

      respond_to do |format|
        format.html {render partial: 'post_loader'}
      end
    else
      respond_to do |format|
        format.html {render nothing: true}
      end
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
  # all posts sorted on either:
  # approved (true for: main, school, bestof, search;  false for: vote, user)
  # school_specific (true for: main, vote, bestof; false for: school, user, search) -- user must be signed in
  # user (string - only for user)
  # school (string - only for school)
  # q (string - only for search)
  def find_posts
    approved    = session[:posts].fetch(:approved, true)
    school_name = session[:posts].fetch(:school_name, nil)
    for_user    = session[:posts].fetch(:for_user, false)
    date_limit  = session[:posts].fetch(:date_limit, false)
    post_order  = session[:posts].fetch(:order, 'created_at DESC')
    page_num    = session[:posts].fetch(:page_num, Time.now)
    per_page    = 15
    # multiple assignments of @posts essentially works as chaining .where() since .where() is not immediately evaluated/queried
    @posts =   Post.where( ['posts.created_at < ?', page_num] ).with_associated
    if school = school_name || current_user.try(:college).try(:name) || false
      @posts = @posts.where(['school_specific = false OR colleges.name = ?', school])
    else
      @posts = @posts.where( school_specific: false)
    end
    @posts = @posts.where( 'colleges.name = ?', school_name) if school_name
    @posts = @posts.where( approved: approved )
    @posts = @posts.where( ['posts.created_at > ?', date_limit] ) if date_limit.present?
    @posts = @posts.where( user_id: for_user) if for_user
    
    #@posts = @posts.where( [ "SELECT * FROM posts WHERE text % ?", params[:q] ] ) if params.has_key?(:q) # search page
    
    @posts = @posts.order( post_order )
    @posts = @posts.limit(per_page)
    session[:posts][:page_num] = @posts.last.created_at unless @posts.empty?
    @posts
  end
end
