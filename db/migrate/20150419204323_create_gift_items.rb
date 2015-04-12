class CreateGiftItems < ActiveRecord::Migration
  def change
    create_table :gift_items do |t|
      t.string :title
      t.references :user, index: true
      t.integer  :quantity
      t.string   :unit
      t.text     :description
      t.boolean  :active,          default: true
      t.string   :used_time
      t.string   :measures
      t.string   :weight
      t.string   :status
      t.timestamps
    end
  end
end
