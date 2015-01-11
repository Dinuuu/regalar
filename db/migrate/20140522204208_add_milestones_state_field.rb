class AddMilestonesStateField < ActiveRecord::Migration
  def self.up
    add_column :milestones, :aasm_state, :string
  end

  def self.down
    remove_column :milestones, :aasm_state
  end
end
