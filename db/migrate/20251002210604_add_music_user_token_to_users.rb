class AddMusicUserTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :music_user_token, :string
  end
end
