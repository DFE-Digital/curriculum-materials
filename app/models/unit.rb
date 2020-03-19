class Unit < ApplicationRecord
  validates :complete_curriculum_programme_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 128 }

  validates :summary,
            presence: true,
            length: { maximum: 1024 }

  validates :rationale, presence: true
  validates :guidance, presence: true
  validates :year, inclusion: SchoolYear.instance.years

  belongs_to :complete_curriculum_programme
  has_many :lessons, dependent: :destroy

  scope :at_year, ->(year) { where(year: year) }
  scope :ordered_by_position, -> { order(position: 'asc') }
end
