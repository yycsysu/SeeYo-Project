class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user_yochat

  def create
    @comment = @yochat.comments.build(comment_params)
    @comment.like = 0
    @comment.user = @user

    respond_to do |format|
      if @comment.save
        #Message.create(:user => @yochat.user, :classes => "yochat", :msg_id => @comment.id, :sender_id => @user.id)
        format.js
        format.html { redirect_to root_path, notice: 'Comment was successfully created!' }
      else
        format.html { render "create", alert: 'Comment created faild!' }
      end
    end
  end

  private
  def set_user_yochat
    @user = current_user
    @yochat = Yochat.find(params[:yochat_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
