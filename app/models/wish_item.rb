class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  has_many :comments, as: :commentable
  validates :title, :reason, :priority, :quantity, :obtained,
            :description, :main_image, :unit, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :obtained,  numericality: { greater_than_or_equal_to: 0 }
  mount_uploader :main_image, ImageUploader

  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :goal_reached, -> { where('quantity < obtained') }
  scope :goal_not_reached, -> { where.not('quantity < obtained') }
  scope :finished, -> { where('(?) >= finish_date', Time.current) }
  scope :not_finished, -> { where('(?) < finish_date', Time.current) }
  scope :not_paused, -> { where(active: true) }
  scope :paused, -> { where.not(active: true) }

  validate :check_finish_date, if: proc { finish_date.present? && self.finish_date_changed? }

  def confirmed_donations
    Donation.for_wish_item(self).confirmed
  end

  def pending_donation(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).first
  end

  def self.trending
    WishItem.goal_not_reached.last(4)
  end

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
  end

  def pause
    update_attributes!(active: false)
  end

  def resume
    update_attributes!(active: true)
  end

  def gifted?
    quantity < obtained
  end

  def finished?
    return false unless finish_date.present?
    finish_date < DateTime.current
  end

  private

  def check_finish_date
    return true if finish_date > DateTime.current
    errors.add(:finish_date, 'it has to finish after now')
  end
end
