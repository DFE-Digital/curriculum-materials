class CompleteCurriculumProgramme < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }
  validates :rationale, presence: true

  has_many :units, dependent: :destroy
  belongs_to :subject

  # Stub implementation until we associate ccps with years
  def year
    'TODO!!'
  end
end
