class CreateGiftItemImages < ActiveRecord::Migration
  def change
    create_table :gift_item_images do |t|
      t.string :file
      t.references :gift_item

      t.timestamps
    end
  end
end
