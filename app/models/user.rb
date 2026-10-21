class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { user: "user", admin: "admin" }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
