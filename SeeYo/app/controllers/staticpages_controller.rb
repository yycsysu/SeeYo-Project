class StaticpagesController < ApplicationController

  before_filter :authenticate_user!, :except => [:welcome]

  def welcome
    if current_user
      if !current_user.information
        info = current_user.create_information
        info.gender = "male";
        info.location = "China";
        info.about = "I ll die tomorrow"
        info.birthday = "1990-11-11"
        info.blog = "localhost"
        info.save
      end
      redirect_to users_path
    end
    @page_title = "Welcome to SeeYo"
  end

  def plaza
    @page_title = "Plaza - where you can make friends with others"
    @title = "Plaza"
    @yochats = Yochat.all.reverse
  end
end
