module Teachers
  module LessonPartsHelper
    def lesson_part_breadcrumbs(lesson_part)
      {
        lesson_part.lesson.unit.complete_curriculum_programme.name =>
          teachers_complete_curriculum_programme_path(lesson_part.lesson.unit.complete_curriculum_programme),

          lesson_part.lesson.unit.name => teachers_unit_path(lesson_part.lesson.unit),

          lesson_part.lesson.name => teachers_lesson_path(lesson_part.lesson)
      }
    end

    def activity_choice_link(teacher, lesson_part)
      if lesson_part.activity_choices.any?
        edit_teachers_lesson_part_choice_path(lesson_part)
      else
        new_teachers_lesson_part_choice_path(lesson_part)
      end
    end
  end
end
