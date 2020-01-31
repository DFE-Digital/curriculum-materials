module LessonsHelper
  def lessons_breadcrumbs(lesson)
    {
      lesson.unit.complete_curriculum_programme.name =>
        complete_curriculum_programme_path(lesson.unit.complete_curriculum_programme),

      lesson.unit.name => unit_path(lesson.unit)
    }
  end
end
