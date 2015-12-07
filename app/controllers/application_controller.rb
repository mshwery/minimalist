class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session# with: :exception

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def default_serializer_options
    {root: false}
  end

  # Devise without :database_authenticatable
  # @see https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview#using-omniauth-without-other-authentications
  def new_session_path(scope)
    new_user_session_path
  end
  
  private

  def record_not_found
    render json: { error: "record not found" }, status: 404
  end
end
