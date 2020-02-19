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
      # FIXME replace this when we get a proper set of icons with
      #       a real naming convention, etc.

      # options currently are:
      #
      # thumb-formative-inv.png
      # thumb-group-inv.png
      # thumb-individual-inv.png
      # thumb-pair-inv.png
      # thumb-practical-inv.png
      # thumb-reading-inv.png
      # thumb-whole-inv.png
      # thumb-worksheet-inv.png
      # thumb-writing-inv.png

      image_tag(
        asset_pack_path("media/images/placeholder-icons/thumb-#{teaching_method.icon}-inv.png"),
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
