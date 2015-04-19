class AddAttributesToWishitem < ActiveRecord::Migration
  def change
    add_column :wish_items, :measures, :string
    add_column :wish_items, :weight, :string
  end
end
