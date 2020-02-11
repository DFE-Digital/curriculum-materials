class Resource < ApplicationRecord
  belongs_to :activity
  validates :activity, presence: true
  validates :name,
            presence: true,
            length: { maximum: 256 }
  validates :sha256,
              presence: true,
              length: { maximum: 64 }
  validates :uri,
            presence: true
end
