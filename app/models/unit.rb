class Unit < ApplicationRecord
  validates :complete_curriculum_programme_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 256 }

  validates :overview,
            presence: true,
            length: { maximum: 1024 }

  validates :benefits, presence: true
  validates :year, inclusion: SchoolYear.instance.years

  belongs_to :complete_curriculum_programme
  has_many :lessons, dependent: :destroy
end
