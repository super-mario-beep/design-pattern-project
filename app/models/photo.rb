class Photo < ApplicationRecord
  FORMATS = %w[ jpg png bmp ].freeze

  belongs_to :user
  has_many :photo_hashtags, dependent: :destroy
  has_many :hashtags, through: :photo_hashtags

  validates :storage_key, :byte_size, presence: true
  validates :format, inclusion: { in: FORMATS }

  scope :latest, -> { order(created_at: :desc) }

  after_destroy_commit :delete_file

  def hashtag_list
    hashtags.map(&:name).join(" ")
  end

  def hashtag_list=(text)
    names = text.to_s.split(/[\s,]+/).map { |name| Hashtag.normalize_value_for(:name, name) }.compact_blank.uniq
    self.hashtags = names.map { |name| Hashtag.find_or_create_by!(name: name) }
  end

  private
    def delete_file
      StorageAdapter.current.delete(storage_key)
    end
end
