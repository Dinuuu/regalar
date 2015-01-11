class Contribution < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :perk
  belongs_to :user

  has_one :purchase

  validates :amount, numericality: { greater_than: 0 }

end
