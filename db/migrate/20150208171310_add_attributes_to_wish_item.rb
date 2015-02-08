class AddAttributesToWishItem < ActiveRecord::Migration
  def change
    add_column :wish_items, :quantity, :text
    add_column :wish_items, :priority, :string
    add_column :wish_items, :description, :text
    add_column :wish_items, :unit, :string
  end
end
