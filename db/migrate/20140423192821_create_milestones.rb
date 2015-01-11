class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name
      t.text :description
      t.datetime :done_date
      t.float :amount
      t.references :campaign, index: true
      t.boolean :approved

      t.timestamps
    end
  end
end
