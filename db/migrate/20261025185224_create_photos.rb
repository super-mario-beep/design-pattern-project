class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.string :storage_key, null: false
      t.string :original_filename
      t.string :format, null: false
      t.integer :byte_size, null: false
      t.integer :width
      t.integer :height

      t.timestamps
    end
    add_index :photos, :storage_key, unique: true
    add_index :photos, :created_at
  end
end
