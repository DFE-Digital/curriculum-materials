module Teachers
  module LessonsHelper
    def lessons_breadcrumbs(lesson)
      {
        lesson.unit.complete_curriculum_programme.name =>
          teachers_complete_curriculum_programme_path(lesson.unit.complete_curriculum_programme),

        lesson.unit.name => teachers_unit_path(lesson.unit)
      }
    end
  end
end
