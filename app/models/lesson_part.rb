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

  scope :ordered_by_position, -> { order(position: 'asc') }

  def activity_for(teacher)
    retrieve_selected_activity(teacher) || retrieve_default_activity || retrieve_fallback_activity
  end

private

  def retrieve_selected_activity(teacher)
    activity_choice = if activity_choices.loaded?
                        activity_choices.detect { |ac| ac.teacher_id == teacher.id }
                      else
                        activity_choices.find_by(teacher_id: teacher.id)
                      end

    activity_choice&.activity
  end

  def retrieve_default_activity
    return nil if default_activity_id.blank?

    if activities.loaded?
      activities.detect { |activity| activity.id == default_activity_id }
    else
      activities.find_by(id: default_activity_id)
    end
  end

  def retrieve_fallback_activity
    activities.first
  end
end
