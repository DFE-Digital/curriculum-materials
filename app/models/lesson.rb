class Lesson < ContentBase
  attr_accessor :title, :description, :weight

  belongs_to :unit
  has_many :activities, pattern: "*.md"

  alias name title
  alias summary description

  def path
    Rails.application.routes.url_helpers.teachers_complete_curriculum_programme_unit_lesson_path(
      unit.ccp,
      unit,
      self
    )
  end

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

  def previous_knowledge
    hash = {}
    alternatives.each do |alternative_lesson|
      hash[alternative_lesson.title] = alternative_lesson.description
    end
    hash
  end

  def activities
    files = Dir.glob(File.join(File.dirname(@filename), "*.md"))
    files.reject do |file|
      file.ends_with? '_index.md'
    end.collect do |file|
      Activity.from_file(file)
    end.sort_by do |file|
      File.basename(file.filename, File.extname(file.filename)).to_f
    end
  end

  def duration
    parts.inject(0) do |sum, activity|
      sum + (activity.duration || 0)
    end
  end

  def part
    File.basename(@filename, File.extname(@filename)).to_f
  end

  def number
    part.to_i
  end

  def parts
    arr = []
    counter = 0
    activities.each do |activity|
      if activity.part.to_i > counter
        arr << activity
        counter += 1
      end
    end
    arr
  end

  def alternatives
    files = Dir.glob(File.join(File.dirname(@filename.parent), "*/_index.md"))
    filtered_files = files.reject do |file|
      file == @filename.to_s
    end

    filtered_files.collect do |file|
      self.class.from_file(file)
    end
  end
end
