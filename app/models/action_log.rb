class ActionLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :subject, polymorphic: true, optional: true
end
