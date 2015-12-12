class Api::BaseController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :destroy_session

  def default_serializer_options
    {root: false}
  end

  attr_accessor :current_user
  protected

    def api_error(status: 500, errors: [])
      unless Rails.env.production?
        puts errors.full_messages if errors.respond_to? :full_messages
      end
      head status: status and return if errors.empty?

      render json: errors, status: status
    end

    def unauthenticated!
      response.headers['WWW-Authenticate'] = "Token realm=Application"
      render json: { error: 'Bad credentials' }, status: 401
    end

    def authenticate!
      authenticate_or_request_with_http_token do |token, options|
        email = options.blank? ? nil : options[:email]
        user = email && User.find_by(email: email)

        if user && ActiveSupport::SecurityUtils.secure_compare(user.api_token, token)
          @current_user = user
        else
          return unauthenticated!
        end
      end
    end

    def destroy_session
      request.session_options[:skip] = true
    end
  
end
