class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.references :user, index: true
      t.references :campaign, index: true
      t.text :message

      t.timestamps
    end
  end
end
