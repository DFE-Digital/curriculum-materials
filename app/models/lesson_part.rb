class LessonPart < ApplicationRecord
  belongs_to :lesson

  validates :position, 
    presence: true,
    numericality: { only_integer: true, greater_than: 0 }
end
