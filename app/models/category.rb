class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent,  class_name: 'Category', optional: true
  has_many   :children, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy

  has_many :listings

  validates :name, presence: true
end
