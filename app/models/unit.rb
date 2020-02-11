class Unit < ApplicationRecord
  validates :complete_curriculum_programme_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 256 }

  validates :overview,
            presence: true,
            length: { maximum: 1024 }

  validates :benefits, presence: true

  belongs_to :complete_curriculum_programme
  has_many :lessons, dependent: :destroy

  after_validation :set_slug, only: :create

  private

  def set_slug
    self.slug = name.to_s.parameterize unless self.slug.present?
  end
end
