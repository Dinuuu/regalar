class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  validates :title, :reason, :priority, :quantity, :status, :description, :unit, presence: true
  scope :for_organization, -> (organization) { where(organization: organization) }
end
