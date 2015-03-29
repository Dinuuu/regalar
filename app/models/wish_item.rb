class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  validates :title, :reason, :priority, :quantity, :status,
            :description, :main_image, :unit, presence: true

  mount_uploader :main_image, ImageUploader

  scope :for_organization, -> (organization) { where(organization: organization) }

  def pending_donation?(user)
    Donation.where(wish_item_id: id, user_id: user.id).where.not(done: true).any?
  end
end
