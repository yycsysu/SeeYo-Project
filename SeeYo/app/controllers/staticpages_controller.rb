class StaticpagesController < ApplicationController

  before_filter :authenticate_user!, :except => [:welcome]

  def welcome
  end
end
