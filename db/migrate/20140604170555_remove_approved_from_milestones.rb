class RemoveApprovedFromMilestones < ActiveRecord::Migration
  def change
    remove_column :milestones, :approved
  end
end
