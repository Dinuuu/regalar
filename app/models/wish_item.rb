class WishItem < ActiveRecord::Base
  belongs_to :organization
  validates :title, :reason, :priority, :quantity, :status, :description, :unit, presence: true
  scope :for_organization, -> (organization) { where(organization: organization) }
end
