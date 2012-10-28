class PagesController < ApplicationController

  def home
    #render "dashboard" if current_user
    redirect_to user_lists_path(current_user) if current_user
  end

end
