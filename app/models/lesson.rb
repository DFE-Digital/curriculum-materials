class Lesson < ApplicationRecord
  validates :unit_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 128 }

  validates :learning_objective,
            presence: true,
            length: { maximum: 256 }

  belongs_to :unit
  has_many :lesson_parts, dependent: :destroy

  scope :ordered_by_position, -> { order(position: 'asc') }

  def duration
    '1 hour'
  end

  def lesson_parts_for(teacher)
    lesson_parts
      .merge(LessonPart.ordered_by_position)
      .each_with_object({}) { |lesson_part, hash| hash[lesson_part] = lesson_part.activity_for(teacher) }
      .reject { |_, activity| activity.nil? }
  end

  def activities_for(teacher)
    lesson_parts_for(teacher).values
  end
end
