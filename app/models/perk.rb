class Perk < ActiveRecord::Base
  belongs_to :campaign

  validates :amount, :name, :maximum, :description, presence: true
  validates :amount, :maximum, numericality: { greater_than: 0 }
end
