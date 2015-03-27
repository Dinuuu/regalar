class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :level
      t.string :title
      t.integer :from
      t.integer :to

      t.timestamps
    end
  end
end
