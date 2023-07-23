class AddExpiresAtToSpotifyAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :spotify_accounts, :expiresat, :datetime
  end
end
