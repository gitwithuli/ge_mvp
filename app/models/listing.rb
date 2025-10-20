class Listing < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user, optional: true
  belongs_to :category
  belongs_to :location

  has_many_attached :photos

  has_many :favorites, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :messages, through: :conversations

  # avoid :new (conflicts with Listing.new)
  enum :status,    { active: 0, pending: 1, sold: 2, hidden: 3 }
  enum :condition, { brand_new: 0, used: 1 }

  scope :promoted, -> { where('promoted_until > ?', Time.current) }
end