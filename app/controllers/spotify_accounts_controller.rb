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

    private 
    
    def set_spotify_account
        @spotify_account = current_user.spotify_accounts.find(params[:id])
    end
end