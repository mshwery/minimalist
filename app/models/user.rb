class User < ActiveRecord::Base
  has_and_belongs_to_many :lists

  # Include default devise modules. Others available are:
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  before_create :generate_api_token

  # Grab a user by their identity or create a new one
  # @see http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  def self.from_omniauth(auth)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    user = identity.user

    if user.nil?
      # Get the existing user by email if the provider gives us a verified email.
      email = auth.info.email

      # Create the user if it's a new registration
      user = User.where(email: email).first_or_create do |user|
        user.name = auth.info.name
        user.email = email
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    # Return the user
    user
  end

  private

    def generate_api_token
      return if api_token.present?
      
      loop do
        self.api_token = SecureRandom.base64(64)
        break unless User.find_by(api_token: api_token)
      end
    end
  
end
