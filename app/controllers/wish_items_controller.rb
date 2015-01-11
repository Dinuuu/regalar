class WishItemsController < ApplicationController

	inherit_resources
	belongs_to :organization

	def index
		@wish_items = WishItem.for_organization(Organization
                                            .find(params[:organization_id]))
		index!
	end
end
