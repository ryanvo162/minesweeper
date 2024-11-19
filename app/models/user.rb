class User < ApplicationRecord
  has_many :boards

  validates :email, presence: true, uniqueness: true
end
