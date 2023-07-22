class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[spotify]
  has_many :spotify_accounts
  
  def self.from_omniauth(access_token)

    puts "Access Token Info: #{access_token.info}" # Add this line
    data = access_token.info
    user = User.where(email: data['email']).first
    
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    end

    spotify_data = access_token.extra.raw_info
    spotify_account = SpotifyAccount.find_or_initialize_by(user: user)
    spotify_account.update(
      name: spotify_data['display_name'],
      username: spotify_data['id'],
      image: spotify_data['images']&.first&.fetch('url', nil),
      accesstoken: access_token.credentials.token,
      refreshtoken: access_token.credentials.refresh_token
    )

    user
  end   
end
