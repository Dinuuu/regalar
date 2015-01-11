class WishItem < ActiveRecord::Base

	belongs_to :organization

	validates :title, :reason, presence: true

	scope :for_organization, -> (organization) { where(organization: organization) }
end
