class AddPhotoToWishItems < ActiveRecord::Migration
  def change
    add_column :wish_items, :main_image, :string, {:null=>true}
  end
end
