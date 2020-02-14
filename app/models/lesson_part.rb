class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :activities, dependent: :destroy
  has_many :activity_choices, dependent: :destroy

  validates :position,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :position, uniqueness: { scope: :lesson_id }

  def activity_for(teacher)
    ac = ActivityChoice.find_by(teacher_id: teacher.id, lesson_part_id: id)

    if ac.present?
      ac.activity
    else
      activities.where(default: true).first
    end
  end
end
