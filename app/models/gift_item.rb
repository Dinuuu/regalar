class GiftItem < ActiveRecord::Base
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :gift_requests
  validates :title, :quantity, :unit, :description, :used_time, :status, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :given, numericality: { greater_than_or_equal_to: 0 }
  has_many :gift_item_images, inverse_of: :gift_item
  accepts_nested_attributes_for :gift_item_images
  validates :title, :quantity, :unit, :description, :used_time,
            :status, presence: true
  scope :for_user, -> (user) { where(user: user) }
  scope :goal_not_reached, -> { where.not('quantity < given') }

  after_initialize :initialize_attributes

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
  end

  def gifted?
    quantity < given
  end

  def self.trending
    GiftItem.goal_not_reached.last(4)
  end

  def main_image
    gift_item_images.first.file
  end

  def pending_requests(user)
    GiftRequest.for_gift_item(self).for_user(user).where.not(done: true).first
  end

  private

  def initialize_attributes
    self.given ||= 0
  end
end
