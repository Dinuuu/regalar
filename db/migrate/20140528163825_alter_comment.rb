class AlterComment < ActiveRecord::Migration
  def change
    rename_column :comments, :user_id, :commentable_id
    rename_column :comments, :campaign_id, :commentable_type
    change_column :comments, :commentable_type, :string
    add_column :comments, :user_id, :integer
  end
end
