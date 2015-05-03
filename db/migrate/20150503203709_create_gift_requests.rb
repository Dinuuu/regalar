class CreateGiftRequests < ActiveRecord::Migration
  def change
    create_table :gift_requests do |t|
      t.references :user, index: true
      t.references :gift_item, index: true
      t.references :organization, index: true
      t.integer :quantity
      t.boolean :done, :default => false


      t.timestamps
    end
  end
end
