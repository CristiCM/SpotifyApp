class SpotifyAccountsController < ApplicationController
    before_action :require_user_logged_in!
    before_action :set_spotify_account, only: [:destroy]
    before_action :update_refresh_token_if_expired, only: [:previous, :play, :pause, :next, :current_playback]

    def index
        @spotify_accounts = current_user.spotify_accounts
    end

    def destroy
        @spotify_account.destroy
        redirect_to spotify_accounts_path, notice: "Successfully disconnected"
    end

    def previous
      spotify_account = current_user.spotify_accounts.last
    
      if spotify_account.user == current_user
        uri = "https://api.spotify.com/v1/me/player/previous"
    
        response = RestClient::Request.execute(
          method: :post, 
          url: uri,
          headers: { Authorization: "Bearer #{spotify_account.accesstoken}" }
        )
    
        puts "Spotify API status code: #{response.code}" # Log the status code
    
        render json: { status: response.code }
      else
        render json: { error: "Not authorized" }, status: :unauthorized
      end
    end
    

    def play
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = "https://api.spotify.com/v1/me/player/play"
          
          response = RestClient::Request.execute(
            method: :put,
            url: uri,
            headers: { Authorization: "Bearer #{spotify_account.accesstoken}"}
          )

          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
    
    def pause
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = "https://api.spotify.com/v1/me/player/pause"
          
          response = RestClient::Request.execute(
            method: :put,
            url: uri,
            headers: { Authorization: "Bearer #{spotify_account.accesstoken}"}
          )

          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end

    def next
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = "https://api.spotify.com/v1/me/player/next"

          response = RestClient::Request.execute(
            method: :post,
            url: uri,
            headers: { Authorization: "Bearer #{spotify_account.accesstoken}"}
          )
          
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
      
    def current_playback
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = "https://api.spotify.com/v1/me/player"
          
          response = RestClient::Request.execute(
            method: :get,
            url: uri,
            headers: { Authorization: "Bearer #{spotify_account.accesstoken}"}
          )
      
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code, data: JSON.parse(response.body) }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
      
    private 
    
    def set_spotify_account
        @spotify_account = current_user.spotify_accounts.find(params[:id])
    end

    def update_refresh_token_if_expired
      current_user.refresh_tokens_if_expired
    end
end