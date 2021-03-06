class Donation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :wish_item
  validates :user_id, :wish_item_id, :quantity, :organization_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :for_user, -> (user) { where(user: user) }
  scope :for_wish_item, -> (wish_item) { where(wish_item: wish_item) }
  scope :confirmed, -> { where(done: true) }
  scope :pending, -> { where(done: false) }
end
