class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :user, index: true
      t.references :wish_item, index: true
      t.references :organization, index: true
      t.integer :quantity
      t.boolean :done, :default => false

      t.timestamps
    end
  end
end
