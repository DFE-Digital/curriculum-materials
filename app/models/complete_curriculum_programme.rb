class CompleteCurriculumProgramme < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 256 }
  validates :overview,
            presence: true,
            length: { maximum: 1024 }
  validates :benefits, presence: true

  has_many :units, dependent: :destroy

  # Stub implementation until we associate ccps with years
  def year
    'TODO!!'
  end
end
