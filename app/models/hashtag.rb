class Hashtag < ApplicationRecord
  has_many :photo_hashtags, dependent: :destroy
  has_many :photos, through: :photo_hashtags

  normalizes :name, with: ->(name) { name.strip.downcase.gsub(/[^[:alnum:]_]/, "") }

  validates :name, presence: true, uniqueness: true
end
