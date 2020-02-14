module Teachers
  module LessonPartsHelper
    def lesson_part_breadcrumbs(lesson_part)
      {
        lesson_part.lesson.unit.complete_curriculum_programme.name =>
          teachers_complete_curriculum_programme_path(lesson_part.lesson.unit.complete_curriculum_programme),

          lesson_part.lesson.unit.name => teachers_unit_path(lesson_part.lesson.unit),

          "Part #{lesson_part.position}" => '#'
      }
    end

    def activity_choice_link(teacher, lesson_part)
      if ActivityChoice.exists?(teacher: teacher, lesson_part: lesson_part)
        edit_teachers_lesson_part_choice_path(lesson_part)
      else
        new_teachers_lesson_part_choice_path(lesson_part)
      end
    end
  end
end
