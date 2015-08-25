class UsersController < ApplicationController
  before_filter :set_user, only: [:show, :edit, :update]
  before_filter :validate_authorization_for_user, only: [:edit, :update]

  def index
    redirect_to root_url
  end


  # GET /users/1
  def show
    @user = User.find params[:id]
    @can_edit = (user_signed_in?) ? (current_user.id == params[:id].to_i) : false

    gon.post_params = {
      approved: true,
      order: 'created_at DESC',
      uid: params[:id]
    }
    if user_signed_in? && current_user.college.present?
      gon.post_params[:specific] = !current_user.college.name.nil? ? current_user.college.name : false
    end
  end

  # GET /users/1/edit
  def edit
    if user_signed_in?
      if  current_user.id == params[:id].to_i
        @can_edit = true
      else
        redirect_to current_user
      end
    else
      redirect_to root_url
    end
  end


  # PATCH/PUT /users/1
  def update
    if params.has_key? :user
      if params.has_key? :college_name
        college = params[:college_name] 
        @user.college_id = College.find_by_name(college).id
      end
      @user.name = params[:user][:name] if params[:user].has_key? :name
      @user.save

      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find params[:id]
    end

    def validate_authorization_for_user
       redirect_to root_url unless @user == current_user
    end

  end
