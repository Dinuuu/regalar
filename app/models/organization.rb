class Organization < ActiveRecord::Base
  has_many :campaigns
  has_and_belongs_to_many :users
  has_many :comments, as: :commentable
  has_many :wish_list, class_name: 'WishItem'

  validates :name, :description, :locality, presence: true

end
