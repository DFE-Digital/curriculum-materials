class CompleteCurriculumProgramme < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }
  validates :rationale, presence: true
  validates :key_stage, inclusion: SchoolYear.instance.key_stages

  has_many :units, dependent: :destroy
  belongs_to :subject
end
