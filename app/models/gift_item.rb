class GiftItem < ActiveRecord::Base
  belongs_to :user
  validates :quantity, numericality: { greater_than: 0 }
  validates :given, numericality: { greater_than_or_equal_to: 0 }
  has_many :gift_item_images, inverse_of: :gift_item
  accepts_nested_attributes_for :gift_item_images
  validates :title, :quantity, :unit, :description, :used_time,
            :status, presence: true

  scope :for_user, -> (user) { where(user: user) }

  after_initialize :initialize_attributes

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
  end

  private

  def initialize_attributes
    self.given ||= 0
  end
end
