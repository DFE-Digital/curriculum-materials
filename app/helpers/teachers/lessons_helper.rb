module Teachers
  module LessonsHelper
    def lessons_breadcrumbs(lesson)
      {
        lesson.unit.complete_curriculum_programme.name =>
          teachers_complete_curriculum_programme_path(lesson.unit.complete_curriculum_programme),

        lesson.unit.name => teachers_unit_path(lesson.unit)
      }
    end

    def activity_icon(teaching_method)
      image_tag(
        asset_pack_path("media/images/activity-icons/#{teaching_method.icon}.png"),
        width: '75px',
        alt: "#{teaching_method.description} icon"
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
