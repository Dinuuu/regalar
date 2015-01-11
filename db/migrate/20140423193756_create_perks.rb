class CreatePerks < ActiveRecord::Migration
  def change
    create_table :perks do |t|
      t.references :campaign, index: true
      t.float :amount
      t.string :name
      t.integer :maximun
      t.text :description

      t.timestamps
    end
  end
end
