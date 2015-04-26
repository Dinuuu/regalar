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
  scope :finished, -> { where(quantity: 0) }
  scope :not_finished, -> { where.not(quantity: 0) }

  def confirmed_donations
    Donation.for_wish_item(self).confirmed
  end

  def pending_donation(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).first
  end

  def self.trending
    WishItem.not_finished.last(4)
  end

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
  end

  def stop
    update_attributes!(active: false)
  end

  def resume
    update_attributes!(active: true)
  end
end
