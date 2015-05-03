class GiftItemImage < ActiveRecord::Base
  mount_uploader :file, ImageUploader
  belongs_to :gift_item
end
