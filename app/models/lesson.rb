class Lesson < ContentBase
  attr_accessor :title, :description, :weight

  def from_file(file)
    super
  end

  def unit
    @unit ||= Unit.new
    @unit.from_file(File.join(@filename.parent.parent, "_index.md"))
    @unit
  end

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_unit_lesson_path(
      unit.ccp,
      unit,
      self
    )
  end

  alias name title
  alias summary description

  def vocabulary
    []
  end
  deprecate :vocabulary

  def misconceptions
    []
  end
  deprecate :misconceptions

  def core_knowledge
    ""
  end
  deprecate :core_knowledge
end
