class AddDefaultToObtained < ActiveRecord::Migration
  def change
    change_column :wish_items, :obtained, :integer, :default => 0, :null => false
  end
end
