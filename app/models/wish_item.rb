class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  validates :title, :reason, :priority, :quantity, :status, :description, :unit, presence: true
  scope :for_organization, -> (organization) { where(organization: organization) }

  def pending_donation?(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).any?
  end

  def confirmed_donations
    Donation.for_wish_item(self).done
  end
end
