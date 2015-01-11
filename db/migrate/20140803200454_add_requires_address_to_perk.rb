class AddRequiresAddressToPerk < ActiveRecord::Migration
  def change
    add_column :perks, :requires_address, :boolean
  end
end
