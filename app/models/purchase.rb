class Purchase < ActiveRecord::Base
  belongs_to :contribution

  validates :status, presence: true

  scope :confirmed_amount, lambda { |campaign|
    joins(:contribution)
    .where(status: :success)
    .where(contributions: { campaign_id: campaign.id })
    .sum(:amount)
  }
end
