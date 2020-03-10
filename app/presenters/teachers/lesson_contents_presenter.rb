module Teachers
  class LessonContentsPresenter
    class Slot
      attr_reader :counter, :teaching_methods, :name, :overview, :duration,
                  :extra_requirements, :lesson_part, :alternatives

      def initialize(counter, lesson_part, activity)
        @counter            = counter
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
      @contents = lesson
        .lesson_parts_for(teacher)
        .map
        .with_index(1) { |(lesson_part, activity), i| Slot.new(i, lesson_part, activity) }
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
