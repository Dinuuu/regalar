class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :comments, as: :commentable
  has_many :wish_items
  has_many :donations
  validates :name, :description, :locality, :email, :logo, presence: true
  validates :email, format: { with: Devise.email_regexp }
  validates :email, uniqueness: { case_sensitive: false }

  mount_uploader :logo, ImageUploader

  def pending_donations
    Donation.for_organization(self).pending
  end

  def confirmed_donations
    Donation.for_organization(self).confirmed
  end

  def trending_wish_items
    WishItem.for_organization(self).not_finished.last(3)
  end
end
