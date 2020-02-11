class CompleteCurriculumProgramme < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 256 }
  validates :overview,
            presence: true,
            length: { maximum: 1024 }
  validates :benefits, presence: true

  has_many :units, dependent: :destroy

  after_validation :set_slug, only: :create

  # Stub implementation until we associate ccps with years
  def year
    'TODO!!'
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize unless self.slug.present?
  end
end
