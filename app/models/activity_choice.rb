class ActivityChoice < ApplicationRecord
  belongs_to :teacher
  belongs_to :activity
  belongs_to :lesson_part

  validates :teacher, :activity, :lesson_part, presence: true
  validates :teacher_id, uniqueness: { scope: :lesson_part_id }

  scope :made_by, -> (teacher) { where(teacher: teacher) }
end
