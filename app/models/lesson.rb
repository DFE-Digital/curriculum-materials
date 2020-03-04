class Lesson < ApplicationRecord
  validates :unit_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 256 }

  validates :summary, presence: true

  belongs_to :unit
  has_many :lesson_parts, dependent: :destroy

  scope :ordered_by_position, -> { order(position: 'asc') }

  def duration
    '1 hour'
  end

  def lesson_parts_for(teacher)
    lesson_parts
      .each_with_object({}) { |lesson_part, hash| hash[lesson_part] = lesson_part.activity_for(teacher) }
      .reject { |_, activity| activity.nil? }
  end
end
