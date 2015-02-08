class WishItem < ActiveRecord::Base
  belongs_to :organization
  validates :title, :reason, :priority, :quantity, :description, :unit, presence: true
  scope :for_organization, -> (organization) { where(organization: organization) }
end
