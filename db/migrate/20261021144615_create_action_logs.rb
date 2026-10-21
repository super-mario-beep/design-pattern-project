class CreateActionLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :action_logs do |t|
      # Optional because guests can act too; logs are kept when a user is deleted
      t.references :user, foreign_key: { on_delete: :nullify }
      t.references :subject, polymorphic: true
      t.string :action, null: false
      t.json :details

      t.timestamps
    end
    add_index :action_logs, [ :action, :created_at ]
  end
end
