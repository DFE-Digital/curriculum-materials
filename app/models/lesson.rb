class Lesson < ApplicationRecord
  validates :unit_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 256 }

  validates :summary, presence: true

  belongs_to :unit

  has_many :lesson_parts, dependent: :destroy

  def duration
    '1 hour'
  end

  after_validation :set_slug, only: :create

  private

  def set_slug
    self.slug = name.to_s.parameterize unless self.slug.present?
  end
end
