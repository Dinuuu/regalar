class GiftRequest < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :gift_item
  validates :user_id, :gift_item_id, :quantity, :organization_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :for_user, -> (user) { where(user: user) }
  scope :for_gift_item, -> (gift_item) { where(gift_item: gift_item) }
  scope :confirmed, -> { where(done: true) }
  scope :pending, -> { where(done: false) }
end
