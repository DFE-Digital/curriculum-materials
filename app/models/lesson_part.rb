class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :activities, dependent: :destroy
  has_many :activity_choices, dependent: :destroy

  validates :position,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :position, uniqueness: { scope: :lesson_id }

  scope :ordered_by_position, -> { order(position: 'asc') }

  def activity_for(teacher)
    activity_choice = activity_choices.find_by(teacher_id: teacher.id)

    return activity_choice.activity if activity_choice.present?

    activities.find_by(default: true) || activities.first
  end
end
