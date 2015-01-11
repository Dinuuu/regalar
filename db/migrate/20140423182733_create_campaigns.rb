class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.float :goal
      t.datetime :deadline
      t.float :minimum
      t.string :category
      t.string :locality
      t.references :organization, index: true
      t.text :short_description

      t.timestamps
    end
  end
end
