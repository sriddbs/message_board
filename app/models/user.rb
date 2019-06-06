class User < ApplicationRecord
  ROLES = [:user, :moderator, :admin].freeze

  validates :email, presence: true

  has_many :messages

  enum role: ROLES
end
