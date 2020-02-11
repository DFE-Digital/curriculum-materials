class CompleteCurriculumProgramme < ContentBase
  attr_accessor :title, :content, :description

  alias name title
  alias overview content
  alias benefits description

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_path(
      self
    )
  end

  def units
    files = Dir.glob(File.join(File.dirname(@filename), "*/_index.md"))
    files.collect do |file|
      l = Unit.new
      l.from_file(file)
      l
    end
  end

  def year
    "TODO"
  end
end
