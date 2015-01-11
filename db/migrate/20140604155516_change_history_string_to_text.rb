class ChangeHistoryStringToText < ActiveRecord::Migration
  def change
     change_column :campaigns, :history, :text
  end
end
