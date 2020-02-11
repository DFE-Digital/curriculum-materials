class Activity < ContentBase
  attr_accessor :duration, :weight, :taxonomies

  def from_file(file)
    super
  end

  def slug
    ActiveSupport::Inflector.parameterize(
      File.basename(filename, File.extname(filename))
    )
  end

  def lesson
    @lesson ||= Lesson.new
    @lesson.from_file(File.join(@filename.parent, "_index.md"))
    @lesson
  end

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_unit_lesson_activity_path(
      lesson.unit.ccp,
      lesson.unit,
      lesson,
      self
    )
  end
end
