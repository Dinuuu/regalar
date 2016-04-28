class AddSlugToGiftItem < ActiveRecord::Migration
  def change
    add_column :gift_items, :slug, :string
    add_index :gift_items, :slug, unique: true
  end
end
