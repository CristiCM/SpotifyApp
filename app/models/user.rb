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
    unless user
      user = User.create(email: data['email'], password: Devise.friendly_token[0,20])
    end

    update_or_init_spotify_account(user, access_token)

    user
  end
  
  def self.update_or_init_spotify_account(user, access_token)

    spotify_data = access_token.extra.raw_info
    spotify_account = SpotifyAccount.find_or_initialize_by(user: user)

    puts "Access Token: #{access_token.to_hash}"


    spotify_account.update(
      name: spotify_data['display_name'],
      username: spotify_data['id'],
      image: spotify_data['images']&.first&.fetch('url', nil),
      accesstoken: access_token.credentials.token,
      refreshtoken: access_token.credentials.refresh_token,
      expiresat: Time.at(access_token.credentials.expires_at).to_datetime
    )
  end

  def refresh_tokens_if_expired
    spotify_accounts.each do |spotify_account|
      if token_expired?(spotify_account)
        body = {
          grant_type: 'refresh_token',
          refresh_token: spotify_account.refreshtoken,
          client_id: ENV['SPOTIFY_CLIENT_ID'],
          client_secret: ENV['SPOTIFY_CLIENT_SECRET']
        }
        response = RestClient.post('https://accounts.spotify.com/api/token', body)
        refreshhash = JSON.parse(response.body)
    
        spotify_account.accesstoken = refreshhash['access_token']
        spotify_account.expiresat = DateTime.now + refreshhash['expires_in'].seconds
    
        spotify_account.save
      end
    end
  end
  
  def token_expired?(spotify_account)
    expiry = Time.at(spotify_account.expiresat)
    return true if expiry < Time.now
    false
  end
end
