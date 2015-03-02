class AddStateToWishItems < ActiveRecord::Migration
  def change
  	add_column :wish_items, :status, :string
  end
end
