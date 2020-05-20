class CompleteCurriculumProgramme < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }
  validates :rationale, presence: true
  validates :guidance, presence: true
  validates :key_stage, inclusion: SchoolYear.instance.key_stages

  has_many :units, dependent: :destroy
  belongs_to :subject

  def title
    "Key stage %<key_stage>d %<subject>s" % {
      key_stage: key_stage,
      subject: subject.name
    }
  end
end
