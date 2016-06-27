class WishItem < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :organization
  has_many :donations
  has_many :comments, as: :commentable
  validates :title, :reason, :priority, :quantity, :obtained,
            :description, :unit, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :obtained,  numericality: { greater_than_or_equal_to: 0 }
  mount_uploader :main_image, ImageUploader

  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :for_organizations, -> (organizations) { where(organization_id: organizations) }
  scope :goal_reached, -> { where('quantity <= obtained') }
  scope :goal_not_reached, -> { where.not('quantity <= obtained') }
  scope :finished, -> { where('(?) >= finish_date', Time.current) }
  scope :not_finished, -> { where('(?) < finish_date OR finish_date IS NULL', Time.current) }
  scope :not_paused, -> { where(active: true) }
  scope :paused, -> { where.not(active: true) }
  scope :eliminated, -> { where(eliminated: true) }
  scope :not_eliminated, -> { where.not(eliminated: true) }

  after_initialize :initialize_attributes

  validate :check_finish_date, if: proc { finish_date.present? && self.finish_date_changed? }

  def self.find_by_slug_or_id(param)
    friendly.find(param)
  end

  def confirmed_donations
    Donation.for_wish_item(self).confirmed
  end

  def pending_donation(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).first
  end

  def self.trending(user)
    wishes = WishItem.goal_not_reached
             .not_paused
             .not_finished
             .not_eliminated
             .order('(wish_items.quantity - wish_items.obtained) ASC')
    return wishes.last(3) unless user.present?
    wishes
      .for_organizations(user.organizations.ids)
      .last(3)
  end

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%").not_eliminated
  end

  def pause
    update_attributes!(active: false)
  end

  def resume
    update_attributes!(active: true)
  end

  def eliminate
    update_attributes!(eliminated: true)
  end

  def gifted?
    quantity <= obtained
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

  def initialize_attributes
    self.measures ||= 'N/A'
    self.weight ||= 'N/A'
  end
end
