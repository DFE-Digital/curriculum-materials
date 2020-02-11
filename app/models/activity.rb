class Activity < ApplicationRecord
  belongs_to :lesson_part
  has_many :activity_teaching_methods, dependent: :destroy
  has_many :teaching_methods, through: :activity_teaching_methods

  validates :lesson_part_id, presence: true
  validates :duration, presence: true, numericality: { less_than_or_equal_to: 60 }
  belongs_to :lesson
  validates :lesson, presence: true
  validates :name,
            presence: true,
            length: { maximum: 256 }
  validates :slug, presence: true

  after_validation :set_slug, only: :create

  private

  def set_slug
    self.slug = name.to_s.parameterize unless self.slug.present?
  end
end
