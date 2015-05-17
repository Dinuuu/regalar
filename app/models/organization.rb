class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :comments, as: :commentable
  has_many :wish_items
  has_many :donations
  has_many :gift_requests
  validates :name, :description, :locality, :email, :logo, presence: true
  validates :email, format: { with: Devise.email_regexp }
  validates :email, uniqueness: { case_sensitive: false }
  validate :uri_format, if: proc { website.present? }
  mount_uploader :logo, ImageUploader

  def uri_format
    uri = URI.parse(website)
    errors.add(:website, 'invalid website') unless
      %w( http https ).include?(uri.scheme)
  rescue StandardError
    errors.add(:website, 'invalid website')
  end

  def pending_donations
    Donation.for_organization(self).pending
  end

  def confirmed_donations
    Donation.for_organization(self).confirmed
  end

  def pending_gift_requests
    GiftRequest.for_organization(self).pending
  end

  def confirmed_gift_requests
    GiftRequest.for_organization(self).confirmed
  end

  def trending_wish_items
    WishItem.for_organization(self).goal_not_reached.last(3)
  end

  def self.search(search_condition)
    where('lower(name) LIKE ? OR lower(description) LIKE ?',
          "%#{search_condition.downcase}%", "%#{search_condition.downcase}%")
  end
end
