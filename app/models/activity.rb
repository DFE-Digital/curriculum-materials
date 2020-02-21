class Activity < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w(image/png).freeze
  MAX_UPLOAD_SIZE = 50.megabytes

  belongs_to :lesson_part
  has_many :activity_teaching_methods, dependent: :destroy
  has_many :activity_choices, dependent: :destroy
  has_many :teaching_methods, through: :activity_teaching_methods

  has_many_attached :teacher_resources
  has_many_attached :pupil_resources

  validates :lesson_part_id, presence: true
  validates :name, presence: true, length: { maximum: 128 }
  validates :overview, presence: true
  validates :duration, presence: true, numericality: { less_than_or_equal_to: 60 }

  validates :default, inclusion: [true, false]
  validates :default, uniqueness: { scope: :lesson_part_id }, if: :default?

  validates :teacher_resources,
            content_type: ALLOWED_CONTENT_TYPES,
            size: { less_than: MAX_UPLOAD_SIZE }

  validates :pupil_resources,
            content_type: ALLOWED_CONTENT_TYPES,
            size: { less_than: MAX_UPLOAD_SIZE }

  def alternatives
    [] # TODO return siblings
  end
end
