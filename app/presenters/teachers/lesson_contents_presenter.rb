module Teachers
  class LessonContentsPresenter
    class Slot
      PREVIEWABLE_RESOURCE_TYPES = %w(
        png
        pdf
        gif
      ).freeze

      attr_reader :counter, :teaching_methods, :name, :overview, :duration,
                  :extra_requirements, :lesson_part, :alternatives, :activity

      def initialize(counter, lesson_part, activity)
        @counter            = counter
        @teaching_methods   = activity.teaching_methods
        @name               = activity.name
        @overview           = activity.overview
        @duration           = activity.duration
        @extra_requirements = activity.extra_requirements || []
        @alternatives       = activity.alternatives
        @lesson_part        = lesson_part
        @activity           = activity
      end

      def resources
        [
          @activity.pupil_resources,
          @activity.teacher_resources,
          @activity.slide_deck
        ].select(&:attached?)
          .flatten
          .select { |r| PREVIEWABLE_RESOURCE_TYPES.include? r.filename.extension }
      end
    end

    attr_reader :lesson, :teacher, :contents

    def initialize(lesson, teacher)
      @lesson  = lesson
      @teacher = teacher

      @contents = load_parts
        .each_with_object({}) { |lesson_part, hash| hash[lesson_part] = lesson_part.activity_for(teacher) }
        .reject { |_, activity| activity.nil? }
        .map
        .with_index(1) { |(lesson_part, activity), i| Slot.new(i, lesson_part, activity) }
    end

  private

    def load_parts
      @lesson
        .lesson_parts
        .eager_load(
          :activity_choices,
          activities: %i(activity_teaching_methods teaching_methods pupil_resources_attachments teacher_resources_attachments slide_deck_attachment)
        )
        .merge(LessonPart.ordered_by_position)
        .merge(Activity.ordered_by_id)
        .merge(ActivityChoice.made_by(@teacher).or(ActivityChoice.where(teacher_id: nil)))
    end
  end
end
