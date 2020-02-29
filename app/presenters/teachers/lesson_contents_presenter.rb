module Teachers
  class LessonContentsPresenter
    class Slot
      attr_reader :position, :teaching_methods, :name, :overview, :duration,
                  :extra_requirements, :lesson_part, :alternatives

      def initialize(lesson_part, activity)
        @position           = lesson_part.position
        @teaching_methods   = activity.teaching_methods
        @name               = activity.name
        @overview           = activity.overview
        @duration           = activity.duration
        @extra_requirements = activity.extra_requirements || []
        @alternatives       = activity.alternatives
        @lesson_part        = lesson_part
      end
    end

    attr_reader :contents

    def initialize(lesson, teacher)
      @contents = load_parts(lesson, teacher)
        .each_with_object({}) { |lesson_part, hash| hash[lesson_part] = lesson_part.activity_for(teacher) }
        .reject { |_, activity| activity.nil? }
        .map { |lesson_part, activity| Slot.new(lesson_part, activity) }
    end

  private

    def load_parts(lesson, teacher)
      lesson
        .lesson_parts
        .eager_load(default_activity: [:teaching_methods, { activity_teaching_methods: :teaching_method }])
        .eager_load(activity_choices: :activity)
        .eager_load(:activities)
        .merge(ActivityChoice.made_by(teacher).or(ActivityChoice.where(teacher_id: nil)))
    end
  end
end
