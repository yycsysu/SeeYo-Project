class LoginController < ApplicationController
  def index
  end

  def check
    unless request.get?
      username = params[:user][:name].downcase
      password = params[:user][:password].downcase
      @hint = "ok"
      @user = User.find_by_name(username)
      if @user.class == NilClass
        @hint = 'Unregisted Username!'
        render :action => :index 
      elsif @user.password == password 
        @hint = "Welcome back, "
        @username = username
        redirect_to :controller => :homepage
      else
        @hint = "Login failed, please check up you info"
        render :action => :index 
      end
    end
  end

  def event_params
    params.require(:user).permit(:name, :password)
  end
end
