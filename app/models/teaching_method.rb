class TeachingMethod < ApplicationRecord
  has_many :activity_teaching_methods, dependent: :destroy
  has_many :activities, through: :activity_teaching_methods

  validates :name, presence: true, length: { maximum: 32 }
end
