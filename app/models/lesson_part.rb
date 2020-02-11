class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :activities, dependent: :destroy

  validates :position,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :position, uniqueness: { scope: :lesson_id }
end
