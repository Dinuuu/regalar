class AddVisitCountToGiftItem < ActiveRecord::Migration
  def change
    add_column :gift_items, :visits, :integer
  end
end
