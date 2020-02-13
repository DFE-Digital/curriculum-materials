class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :activities, dependent: :destroy

  belongs_to :default_activity_choice, class_name: 'Activity'

  before_validation :assign_default_activity_choice, only: :create

  validates :default_activity_choice, presence: true

  validates :position,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :position, uniqueness: { scope: :lesson_id }

  private

  def assign_default_activity_choice
    unless self.default_activity_choice
      self.default_activity_choice = activities.first
    end
  end
end
