class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_listings, through: :favorites, source: :listing
end