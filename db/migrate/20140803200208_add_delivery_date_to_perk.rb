class AddDeliveryDateToPerk < ActiveRecord::Migration
  def change
    add_column :perks, :delivery_date, :timestamp
  end
end
