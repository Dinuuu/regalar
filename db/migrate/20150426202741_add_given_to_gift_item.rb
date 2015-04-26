class AddGivenToGiftItem < ActiveRecord::Migration
  def change
    add_column :gift_items, :given, :integer
  end
end
