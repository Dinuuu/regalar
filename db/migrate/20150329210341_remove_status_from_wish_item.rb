class RemoveStatusFromWishItem < ActiveRecord::Migration
  def change
  	remove_column :wish_items, :status
  end
end
