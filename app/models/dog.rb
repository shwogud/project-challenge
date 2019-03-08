class Dog < ApplicationRecord
  has_many_attached :images
  
  belongs_to :user
  has_many :likes

  has_many :user_likes,
  through: :likes,
  source: :user
end
