class Supplier < ApplicationRecord
  has_secure_token

  validates :name, presence: true, length: { maximum: 64 }, uniqueness: true
  validates :token, presence: true, length: { is: 24 }, uniqueness: true
end
