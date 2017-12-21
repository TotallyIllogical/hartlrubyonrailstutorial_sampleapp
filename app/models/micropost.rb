class Micropost < ApplicationRecord
  # Joins microposts with user
  belongs_to :user
  # Default sorting
  default_scope -> { order(created_at: :desc) }
  # Makes sure that user is associated with post
  validates :user_id, presence: true
  # Mate sure that content exists and are not longer than 140 character long
  validates :content, length: { maximum: 140 }, presence: true
end
