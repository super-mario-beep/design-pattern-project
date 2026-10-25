class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :photos, dependent: :destroy

  enum :role, { user: "user", admin: "admin" }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :tier_name, inclusion: { in: Tiers::NAMES }
  validates :next_tier_name, inclusion: { in: Tiers::NAMES }, allow_nil: true

  # The tier in effect today
  def tier
    Tiers.for(current_tier_name)
  end

  def current_tier_name
    next_tier_started? ? next_tier_name : tier_name
  end

  # A requested change that has not started yet
  def pending_tier_name
    next_tier_name unless next_tier_started?
  end

  def uploads_today
    ActionLog.where(user: self, action: "photo.uploaded", created_at: Time.current.all_day).count
  end

  def storage_used
    photos.sum(:byte_size)
  end

  def can_change_tier?
    tier_changed_on != Date.current
  end

  # The package can be changed once a day and the new one starts tomorrow
  def request_tier_change(new_tier_name)
    apply_started_tier_change

    if !can_change_tier?
      errors.add(:base, "You can change your package only once a day")
      false
    elsif Tiers::NAMES.exclude?(new_tier_name)
      errors.add(:base, "Choose a package")
      false
    elsif new_tier_name == tier_name
      errors.add(:base, "You are already on this package")
      false
    else
      update(next_tier_name: new_tier_name, next_tier_starts_on: Date.tomorrow, tier_changed_on: Date.current)
    end
  end

  private
    def next_tier_started?
      next_tier_name.present? && next_tier_starts_on <= Date.current
    end

    def apply_started_tier_change
      return unless next_tier_started?

      self.tier_name = next_tier_name
      self.next_tier_name = nil
      self.next_tier_starts_on = nil
    end
end
