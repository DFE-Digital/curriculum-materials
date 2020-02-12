class Unit < ContentBase
  attr_accessor :unit, :weight, :description

  def ccp
    parent_file = File.join(@filename.parent.parent, "_index.md")

    @ccp ||= CompleteCurriculumProgramme.new
    @ccp.from_file(parent_file)
    @ccp
  end

  alias complete_curriculum_programme ccp
  alias name title

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_unit_path(
      ccp,
      self
    )
  end

  alias overview description
  alias benefits content

  def lessons
    files = Dir.glob(File.join(File.dirname(@filename), "*/_index.md"))
    sorted_files = files.sort_by do |file|
      File.dirname(file).split('/').last.to_f
    end
    sorted_files.collect do |file|
      Lesson.from_file(file)
    end
  end
end
