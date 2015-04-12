class AddStatusDetailsToWishItem < ActiveRecord::Migration
  def change
    add_column :wish_items, :active, :boolean, :default => true
    add_column :wish_items, :obtained, :integer, :default => 0
  end
end
