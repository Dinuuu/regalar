class AddSlugToWishItem < ActiveRecord::Migration
  def change
    add_column :wish_items, :slug, :string
    add_index :wish_items, :slug, unique: true
  end
end
