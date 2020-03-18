class Suppliers::TreeComponent < ActionView::Component::Base
  attr_reader :ccp,
              :unit,
              :lesson,
              :lesson_part,
              :activity

  def initialize(ccp: nil, unit: nil, lesson: nil, lesson_part: nil, activity: nil)
    @ccp         = ccp
    @unit        = unit
    @lesson      = lesson
    @lesson_part = lesson_part
    @activity    = activity

    @full_ccp = CompleteCurriculumProgramme
      .eager_load(units: :lessons)
      .find(ccp.id)
  end
end
