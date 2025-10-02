class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :apple_id
      t.string :name
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
