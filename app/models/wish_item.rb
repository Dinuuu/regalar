class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  validates :title, :reason, :priority, :quantity, :status,
            :description, :main_image, :unit, presence: true

  mount_uploader :main_image, ImageUploader

  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :finished, -> { where(quantity: 0) }
  scope :not_finished, -> { where.not(quantity: 0) }

  def pending_donation?(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).any?
  end

  def confirmed_donations
    Donation.for_wish_item(self).done
  end
end
