class Activity < ApplicationRecord
  belongs_to :lesson_part
  has_many :activity_teaching_methods, dependent: :destroy
  has_many :activity_choices, dependent: :destroy
  has_many :teaching_methods, through: :activity_teaching_methods

  validates :lesson_part_id, presence: true
  validates :duration, presence: true, numericality: { less_than_or_equal_to: 60 }

  attr_accessor :default

  after_create :make_default!, if: :default

  def alternatives
    [] # TODO return siblings
  end

  def default?
    lesson_part.default_activity == self
  end

  def make_default!
    lesson_part.update(default_activity: self)
  end
end
