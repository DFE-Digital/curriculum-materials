class CompleteCurriculumProgramme < ContentBase
  attr_accessor :title, :content, :description

  alias name title
  alias overview content
  alias benefits description

  def self.first
    file = Dir.glob(File.join(Rails.root, "content", "*/_index.md")).first
    instance = self.new
    instance.from_file(file)
    instance
  end

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
