class FriendsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_user

  def destroy
    if current_user.id.to_s != params[:user_id] and current_user.id.to_s != params[:id]
      redirect_to :back
    end
    @relation = Friend.where( :userf_id => params[:user_id], :usert_id => params[:id]).first
    @relation.destroy
    flash[:notice] = 'Relationship was successful deleted!'
    redirect_to :back
  end
  
  def create
    focus_u = Friend.where(['(userf_id=? and usert_id=?)', current_user.id, @user.id])
    if focus_u.count > 0
      focus_u.each do |f|
        f.destroy
      end
      flash[:notice] = 'Friend was successful cancled!'
      redirect_to user_url(@user)
    else
      Friend.create(:userf_id => current_user.id, :usert_id => @user.id)
      flash[:notice] = 'Friend was successful added!'
      redirect_to user_url(@user)
    end
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

end
