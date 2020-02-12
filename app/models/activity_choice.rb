class ActivityChoice < ApplicationRecord
  belongs_to :teacher

  def lesson
    file = File.join(Rails.root, 'content', complete_curriculum_programme_slug, unit_slug, lesson_slug, "_index.md")
    Lesson.from_file(file)
  end

  def activity
    lesson.activities.find do |activity|
      activity.slug == activity_slug
    end
  end
end
