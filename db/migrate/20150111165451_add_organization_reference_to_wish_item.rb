class AddOrganizationReferenceToWishItem < ActiveRecord::Migration
  def change
    add_reference :wish_items, :organization, index: true
  end
end
