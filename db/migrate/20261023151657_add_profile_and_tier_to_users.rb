class AddProfileAndTierToUsers < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      t.string :name
      t.string :tier_name, null: false, default: "free"
      t.string :next_tier_name
      t.date :next_tier_starts_on
      t.date :tier_changed_on
    end
  end
end
