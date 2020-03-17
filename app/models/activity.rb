class Activity < ApplicationRecord
  belongs_to :lesson_part
  has_many :activity_teaching_methods, dependent: :destroy
  has_many :activity_choices, dependent: :destroy
  has_many :teaching_methods, through: :activity_teaching_methods
  has_many :teacher_resources, dependent: :destroy, inverse_of: :activity
  has_many :pupil_resources, dependent: :destroy, inverse_of: :activity
  has_one :slide_deck_resource, dependent: :destroy, inverse_of: :activity

  validates :lesson_part_id, presence: true
  validates :name, presence: true, length: { maximum: 128 }
  validates :overview, presence: true
  validates :duration, presence: true, numericality: { less_than_or_equal_to: 60 }

  # the default attr is used to maintain compatibility with the previous approach
  # and allows an activity to be specified as being the default at creation time:w
  attr_accessor :default
  after_create :make_default!, if: :default


  scope :omit, ->(activity) { where.not(id: activity.id) }
  scope :ordered_by_id, -> { order(id: 'asc') }

  def alternatives
    lesson_part.activities.omit(self)
  end

  def default?
    lesson_part.default_activity == self
  end

  def make_default!
    lesson_part.update!(default_activity: self)
  end
end
