class AddEliminatedToWishItem < ActiveRecord::Migration
  def change
    add_column :wish_items, :eliminated, :boolean, default: false
  end
end
