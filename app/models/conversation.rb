class Conversation < ApplicationRecord
  belongs_to :listing
  belongs_to :buyer,  class_name: "User"
  belongs_to :seller, class_name: "User"

  has_many :messages, dependent: :destroy

  # one conversation per buyer per listing
  validates :buyer_id, uniqueness: { scope: :listing_id }

  # allow querying by participant
  scope :for_user, ->(user_or_id) {
    uid = user_or_id.is_a?(User) ? user_or_id.id : user_or_id
    where("buyer_id = :id OR seller_id = :id", id: uid)
  }

  before_validation on: :create do
    self.seller ||= listing.user
  end
end
