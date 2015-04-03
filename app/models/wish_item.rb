class WishItem < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  validates :title, :reason, :priority, :quantity,
            :description, :main_image, :unit, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  mount_uploader :main_image, ImageUploader

  scope :for_organization, -> (organization) { where(organization: organization) }
  scope :finished, -> { where(quantity: 0) }
  scope :not_finished, -> { where.not(quantity: 0) }

  def confirmed_donations
    Donation.for_wish_item(self).confirmed
  end

  def pending_donation(user)
    Donation.for_wish_item(self).for_user(user).where.not(done: true).first
  end

  def self.trending
    WishItem.not_finished.last(4)
  end

  def self.search(search)
    search_condition = '%' + search.downcase + '%'
    find(:all, conditions:
         ['lower(title) LIKE ? OR lower(description) LIKE ?', search_condition, search_condition])
  end
end
