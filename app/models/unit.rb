class Unit < ContentBase
  attr_accessor :unit, :weight, :description

  belongs_to :complete_curriculum_programme
  has_many :lessons

  alias complete_curriculum_programme parent
  alias ccp parent
  alias name title
  alias overview description
  alias benefits content

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_unit_path(
      ccp,
      self
    )
  end
end
