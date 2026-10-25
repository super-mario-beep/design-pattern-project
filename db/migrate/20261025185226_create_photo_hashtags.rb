class CreatePhotoHashtags < ActiveRecord::Migration[8.1]
  def change
    create_table :photo_hashtags do |t|
      t.references :photo, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :photo_hashtags, [ :photo_id, :hashtag_id ], unique: true
  end
end
