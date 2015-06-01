class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_current_user, :only => [:index]
  before_action :set_user, :except => [:index]
  before_action :find_focus, :find_fans, :only => [:show, :index]

  def index
    if @user
      @page_title = "My Homepage"
      @block_title = "YoChats"
      @yochats = @user.yochats.reverse
      @yochat = @user.yochats.build
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id]);
    if params[:operation] == "0"
      @block_title = "Profile"
      @render_name = "profile_show"
    elsif params[:operation] == "1"
      @block_title = "Followers"
      @render_name = "follow_show"
      @users = User.find(@fans)
    elsif params[:operation] == "2"
      @block_title = "Following"
      @render_name = "follow_show"
      @users = User.find(@focus)
    elsif @user.id == current_user.id
      @block_title = "My YoChats"
      @render_name = "yochat_show"
    else
      @block_title = @user.username + "'s YoChats"
      @render_name = "yochat_show"
    end
    if @user
      @yochats = @user.yochats.reverse
      @page_title = @user.username + "'s profile"
    end
  end

  def edit
    @info = @user.information
    respond_to do |format|
      format.js
    end
  end

  private
  def set_current_user
    @user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def find_friends
    @friends = Array.new
    focus = Friend.where(['userf_id=?', @user.id])
    focus.each do |fo|
      if Friend.exists?(:userf_id => fo.usert_id, :usert_id => @user.id)
        @friends.push(fo)
      end
    end
  end

  def find_focus
    if @user
      @focus = Friend.where(['userf_id=?', @user.id]).pluck(:usert_id)
    end
  end

  def find_fans
    if @user
      @fans = Friend.where(['usert_id=?', @user.id]).pluck(:userf_id)
    end
  end

  def yochat_params
    params.require(:yochat).permit(:content, :share_with)
  end

  def yochat_modify
    params.require(:yochat).permit(:share_with)
  end
end
