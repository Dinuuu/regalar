class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :status
      t.references :contribution, index: true
      t.string :success_token
      t.string :failure_token
      t.string :pending_token

      t.timestamps
    end
  end
end
