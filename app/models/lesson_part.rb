class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :activities, dependent: :destroy
  has_many :activity_choices, dependent: :destroy

  # rubocop:disable Rails/InverseOf
  belongs_to :default_activity,
             class_name: 'Activity',
             foreign_key: :default_activity_id,
             optional: true
  # rubocop:enable Rails/InverseOf

  validates :position,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :position, uniqueness: { scope: :lesson_id }

  def activity_for(teacher)
    selected_activity(teacher) || default_activity || fallback_activity
  end

private

  def selected_activity(teacher)
    # if we've eager loaded the activity_choices already, loop through
    # rather than execute a new query
    if activity_choices.loaded?
      activity_choices.detect { |ac| ac.teacher_id == teacher.id }&.activity
    else
      activity_choices.find_by(teacher_id: teacher.id)&.activity
    end
  end

  def fallback_activity
    activities.first
  end
end
