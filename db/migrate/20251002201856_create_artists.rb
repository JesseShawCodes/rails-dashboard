class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.string :apple_id
      t.string :name

      t.timestamps
    end
  end
end
