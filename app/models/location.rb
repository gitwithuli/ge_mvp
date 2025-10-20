class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  KINDS = { country: 0, region: 1, city: 2, district: 3 }.freeze
  attribute :kind, :integer, default: 0

  belongs_to :parent, class_name: 'Location', optional: true
  has_many   :children, class_name: 'Location', foreign_key: :parent_id, dependent: :destroy
  has_many :listings

  validates :name, presence: true

  KINDS.each { |name, val| define_method("#{name}?") { self[:kind] == val } }
end
