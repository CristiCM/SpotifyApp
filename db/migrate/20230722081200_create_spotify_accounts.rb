class CreateSpotifyAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :spotify_accounts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :username
      t.string :image
      t.string :accesstoken
      t.string :refreshtoken

      t.timestamps
    end
  end
end
