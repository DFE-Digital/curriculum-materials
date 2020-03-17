class Resource < ApplicationRecord
  belongs_to :activity
  has_one_attached :file
  has_one_attached :preview

  validates :file, attached: true
end
