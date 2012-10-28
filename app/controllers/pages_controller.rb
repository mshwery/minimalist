class PagesController < ApplicationController

  def home
    redirect_to user_lists_path(current_user) if current_user
  end

end
