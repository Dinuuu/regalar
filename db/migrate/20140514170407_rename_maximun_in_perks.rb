class RenameMaximunInPerks < ActiveRecord::Migration
  def change
    rename_column :perks, :maximun, :maximum
  end
end
