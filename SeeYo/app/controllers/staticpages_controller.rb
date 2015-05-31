class StaticpagesController < ApplicationController

  before_filter :authenticate_user!, :except => [:welcome]
  before_action :set_user
  before_action :find_focus, :find_fans, :only => [:profile, :welcome]
  before_action :set_yochat, :only => [:show, :edit, :update, :destroy]

  def profile
    @profile_user = User.find(params[:id]);
    if @profile_user
      @yochats = @profile_user.yochats.reverse
      @page_title = @profile_user.username + "'s profile"
    end
  end

  def welcome
    if @user
      @page_title = "My Homepage"
      @title = "YoChats"
      @yochats = @user.yochats.reverse
      @yochat = @user.yochats.build
    end
    @page_title = "Welcome to SeeYo"
  end

  def plaza
    @page_title = "Plaza - where you can make friends with others"
    @title = "Plaza"
    @yochats = Yochat.all.reverse
  end

  private
  def set_user
    @user = current_user
  end

  def set_yochat
    @yochat = Yochat.find(params[:id])
  end

  def find_friends
    @friends = Array.new
    focus = Friend.where(['userf_id=?', current_user.id])
    focus.each do |fo|
      if Friend.exists?(:userf_id => fo.usert_id, :usert_id => current_user.id)
        @friends.push(fo)
      end
    end
  end

  def find_focus
    if @user
      @focus = Friend.where(['userf_id=?', @user.id])
    end
  end

  def find_fans
    if @user
      @fans = Friend.where(['usert_id=?', @user.id])
    end
  end

  def yochat_params
    params.require(:yochat).permit(:content, :share_with)
  end

  def yochat_modify
    params.require(:yochat).permit(:share_with)
  end
end
