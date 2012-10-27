class PagesController < ApplicationController

  def home
    render 'dashboard' if current_user
  end

end
