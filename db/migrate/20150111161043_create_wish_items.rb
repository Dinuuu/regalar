class CreateWishItems < ActiveRecord::Migration
  def change
    create_table :wish_items do |t|
      t.string :title
      t.text :reason

      t.timestamps
    end
  end
end
