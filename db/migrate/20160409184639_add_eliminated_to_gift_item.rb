class AddEliminatedToGiftItem < ActiveRecord::Migration
  def change
    add_column :gift_items, :eliminated, :boolean, default: false
  end
end
