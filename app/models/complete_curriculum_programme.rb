class CompleteCurriculumProgramme < ContentBase
  attr_accessor :title, :content, :description

  alias name title
  alias overview content
  alias benefits description

  has_many :units

  class <<self
    def all_files
      Dir.glob(File.join(Rails.root, "content", "*/_index.md"))
    end
  end

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_path(
      self
    )
  end

  def year
    "TODO"
  end
end
