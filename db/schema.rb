# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_25_185226) do
  create_table "action_logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "subject_type"
    t.integer "subject_id"
    t.string "action", null: false
    t.json "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "created_at"], name: "index_action_logs_on_action_and_created_at"
    t.index ["subject_type", "subject_id"], name: "index_action_logs_on_subject"
    t.index ["user_id"], name: "index_action_logs_on_user_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hashtags_on_name", unique: true
  end

  create_table "photo_hashtags", force: :cascade do |t|
    t.integer "photo_id", null: false
    t.integer "hashtag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashtag_id"], name: "index_photo_hashtags_on_hashtag_id"
    t.index ["photo_id", "hashtag_id"], name: "index_photo_hashtags_on_photo_id_and_hashtag_id", unique: true
    t.index ["photo_id"], name: "index_photo_hashtags_on_photo_id"
  end

  create_table "photos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "description"
    t.string "storage_key", null: false
    t.string "original_filename"
    t.string "format", null: false
    t.integer "byte_size", null: false
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_photos_on_created_at"
    t.index ["storage_key"], name: "index_photos_on_storage_key", unique: true
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.string "name"
    t.string "tier_name", default: "free", null: false
    t.string "next_tier_name"
    t.date "next_tier_starts_on"
    t.date "tier_changed_on"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "action_logs", "users", on_delete: :nullify
  add_foreign_key "photo_hashtags", "hashtags"
  add_foreign_key "photo_hashtags", "photos"
  add_foreign_key "photos", "users"
  add_foreign_key "sessions", "users"
end
