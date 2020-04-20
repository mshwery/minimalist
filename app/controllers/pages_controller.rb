class PagesController < ApplicationController

  before_action :redirect_current_user, only: [:home]

  def home
  end

  def dashboard
  end

end
