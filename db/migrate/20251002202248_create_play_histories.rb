class CreatePlayHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :play_histories do |t|
      t.references :song, null: false, foreign_key: true
      t.datetime :played_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
