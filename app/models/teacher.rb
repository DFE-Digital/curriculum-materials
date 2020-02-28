class Teacher < ApplicationRecord
  validates :token,
            presence: true,
            uniqueness: { case_sensitive: false }

  has_many :activity_choices, dependent: :destroy
  has_many :activities, through: :activity_choices

  def chosen_activities(lesson)
    Activity.joins(:activity_choices).where(activity_choices: {
      teacher: self,
      lesson_part: lesson.lesson_parts
    })
  end
end
