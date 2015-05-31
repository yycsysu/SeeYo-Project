class YochatsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user
  before_action :set_yochat, :only => [:show, :edit, :update, :destroy]

  def create
    @yochat = @user.yochats.build(yochat_params)
    @yochat.like = 0;
    respond_to do |format|
      if @yochat.save
        format.js
        format.html { redirect_to root_path, notice: 'Yochat was successfully created!' }
      else
        format.html { render "create", alert: 'Yochat created faild!' }
      end
    end
  end

  def show
    @comments = @yochat.comments.reverse
    puts @comments.count
    @comment = @yochat.comments.build

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @yochat.destroy
    redirect_to yochats_path
    flash[:notice] = "Yochat was successfully deleted!"
  end

  private
  def set_user
    @user = current_user
  end

  def set_yochat
    @yochat = Yochat.find(params[:id])
  end

  def yochat_params
    params.require(:yochat).permit(:content, :share_with)
  end

  def yochat_modify
    params.require(:yochat).permit(:share_with)
  end

end
