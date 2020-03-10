module Teachers
  class LessonContentsPresenter
    class Slot
      attr_reader :counter, :teaching_methods, :name, :overview, :duration,
                  :extra_requirements, :lesson_part_id, :alternatives

      def initialize(counter, lesson_part, activity)
        @counter            = counter
        @teaching_methods   = activity.teaching_methods
        @name               = activity.name
        @overview           = activity.overview
        @duration           = activity.duration
        @extra_requirements = activity.extra_requirements || []
        @alternatives       = activity.alternatives
        @lesson_part_id     = lesson_part.id
      end
    end

    attr_reader :contents

    def initialize(lesson, teacher)
      @contents = lesson
        .lesson_parts_for(teacher)
        .map
        .with_index(1) { |(lesson_part, activity), i| Slot.new(i, lesson_part, activity) }
    end
  end
end
