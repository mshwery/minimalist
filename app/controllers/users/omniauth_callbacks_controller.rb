class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def google_oauth2
  #   @user = User.from_omniauth(request.env['omniauth.auth'])

  #   if @user.persisted?
  #     sign_in_and_redirect :root, event: :authentication
  #   else
  #     redirect_to :root, flash: { error: 'Authentication failed!' }
  #   end
  # end

  def sign_in_with(provider_name)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => provider_name) if is_navigational_format?
  end

  def google_oauth2
    sign_in_with 'Google'
  end
end
