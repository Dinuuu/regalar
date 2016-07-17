class GiftItem < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :comments, as: :commentable
  belongs_to :user
  has_many :gift_requests
  validates :quantity, numericality: { greater_than: 0 }
  validates :given, numericality: { greater_than_or_equal_to: 0 }
  has_many :gift_item_images, inverse_of: :gift_item
  accepts_nested_attributes_for :gift_item_images, allow_destroy: true
  validates :gift_item_images,
            length: { minimum: 1, message: 'Debes seleccionar al menos una imagen' }
  validates :title, :quantity, :unit, :description, :used_time,
            :status, presence: true
  scope :for_user, -> (user) { where(user: user) }
  scope :still_available, -> { where('given < quantity') }
  scope :not_eliminated, -> { where.not(eliminated: true) }

  after_initialize :initialize_attributes

  def self.find_by_slug_or_id(param)
    friendly.find(param)
  end

  def self.search(search_condition)
    where('lower(title) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
      .still_available.not_eliminated
  end

  def available_organization_for_new_request_for_user(user)
    user.organizations
      .where.not(id: gift_requests.where(organization_id: user.organizations.ids)
                                  .pluck(:organization_id))
  end

  def gifted?
    quantity <= given
  end

  def visit
    update_attributes(visits: visits + 1)
  end

  def self.trending(last_visits)
    trending_items = GiftItem.still_available.not_eliminated
    return trending_items.first(4) unless last_visits.present?
    trending_items.where(slug: last_visits).first(4)
  end

  def main_image
    gift_item_images.first.file
  end

  private

  def initialize_attributes
    self.given ||= 0
    self.visits ||= 0
    self.measures ||= 'N/A'
    self.weight ||= 'N/A'
    self.used_time ||= 'N/A'
  end
end
