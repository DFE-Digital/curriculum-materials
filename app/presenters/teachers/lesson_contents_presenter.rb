module Teachers
  class LessonContentsPresenter
    class Slot
      attr_reader :position, :teaching_methods, :name, :overview, :duration,
                  :extra_requirements, :lesson_part_id, :alternatives

      def initialize(lesson_part, activity)
        @position           = lesson_part.position
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
        .lesson_parts
        .each_with_object({}) { |lesson_part, hash| hash[lesson_part] = lesson_part.activity_for(teacher) }
        .reject { |_, activity| activity.nil? }
        .map { |lesson_part, activity| Slot.new(lesson_part, activity) }
    end
  end
end
