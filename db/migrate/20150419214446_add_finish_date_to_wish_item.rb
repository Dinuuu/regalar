class AddFinishDateToWishItem < ActiveRecord::Migration
  def change
    add_column :wish_items, :finish_date, :datetime
  end
end
