class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :campaign, index: true
      t.references :campaign_perk, index: true
      t.references :user, index: true
      t.float :amount

      t.timestamps
    end
  end
end
