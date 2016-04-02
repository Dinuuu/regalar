class GiftItemImage < ActiveRecord::Base
  mount_uploader :file, ImageUploader
  validates :file, presence: true
  belongs_to :gift_item
end
