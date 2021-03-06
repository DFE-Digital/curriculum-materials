module Teachers
  module LessonsHelper
    def lessons_breadcrumbs(lesson)
      {
        lesson.unit.complete_curriculum_programme.title =>
          teachers_complete_curriculum_programme_year_path(lesson.unit.complete_curriculum_programme, lesson.unit.year),

        lesson.unit.name => teachers_unit_path(lesson.unit)
      }
    end

    def activity_icon(teaching_method)
      image_tag(
        asset_pack_path("media/images/activity-icons/#{teaching_method.icon}.png"),
        alt: "#{teaching_method.name} icon",
        class: "activity-icon"
      )
    end

    def activity_thumbnail
      colour = %i(blue orange pink purple yellow).sample

      image_tag(
        asset_pack_path("media/images/placeholder-thumbnails/#{colour}.png"),
        width: '100px'
      )
    end
  end
end
