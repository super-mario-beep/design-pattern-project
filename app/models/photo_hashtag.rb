class PhotoHashtag < ApplicationRecord
  belongs_to :photo
  belongs_to :hashtag
end
