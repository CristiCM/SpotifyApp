class SpotifyAccountsController < ApplicationController
    before_action :require_user_logged_in!
    before_action :set_spotify_account, only: [:destroy]
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
          uri = URI.parse("https://api.spotify.com/v1/me/player/previous")
          request = Net::HTTP::Post.new(uri)
          request["Authorization"] = "Bearer #{spotify_account.accesstoken}"
      
          req_options = {
            use_ssl: uri.scheme == "https",
          }
      
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          puts "Spotify API response: #{response.body}" # Log the response
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end

    def play
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = URI.parse("https://api.spotify.com/v1/me/player/play")
          request = Net::HTTP::Put.new(uri)
          request["Authorization"] = "Bearer #{spotify_account.accesstoken}"
      
          req_options = {
            use_ssl: uri.scheme == "https",
          }
      
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          puts "Spotify API response: #{response.body}" # Log the response
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
    
    def pause
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = URI.parse("https://api.spotify.com/v1/me/player/pause")
          request = Net::HTTP::Put.new(uri)
          request["Authorization"] = "Bearer #{spotify_account.accesstoken}"
      
          req_options = {
            use_ssl: uri.scheme == "https",
          }
      
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          puts "Spotify API response: #{response.body}" # Log the response
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end

    def next
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = URI.parse("https://api.spotify.com/v1/me/player/next")
          request = Net::HTTP::Post.new(uri)
          request["Authorization"] = "Bearer #{spotify_account.accesstoken}"
      
          req_options = {
            use_ssl: uri.scheme == "https",
          }
      
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          puts "Spotify API response: #{response.body}" # Log the response
          puts "Spotify API status code: #{response.code}" # Log the status code
      
          render json: { status: response.code }
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
      
    def current_playback
        spotify_account = current_user.spotify_accounts.last
      
        if spotify_account.user == current_user
          uri = URI.parse("https://api.spotify.com/v1/me/player")
          request = Net::HTTP::Get.new(uri)
          request["Authorization"] = "Bearer #{spotify_account.accesstoken}"
      
          req_options = {
            use_ssl: uri.scheme == "https",
          }
      
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end
      
          puts "Spotify API response: #{response.body}" # Log the response
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
end