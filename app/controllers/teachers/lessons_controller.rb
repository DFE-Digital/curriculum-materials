module Teachers
  class LessonsController < BaseController
    before_action :load_resources, only: %i[show print]

    def show; end

    def print
      render layout: 'print'
    end

    private

    def load_resources
      @lesson = Lesson.find(params[:id])

      # lifted from prototype, these fields should guide
      # the building of the LessonPart model
      @lesson_parts = [
        OpenStruct.new(
          number: 1,
          activity_type: 'Practical',
          involvement: 'Whole class',
          overview: <<~OVERVIEW,
            Pupils demonstrate independent thinking, applying their prior
            knowledge of volcanoes and focussing on the effects of volcanic
            eruptions.

            Ask pupils to watch the video carefully, noting as many words as
            they can about what they observe. Remind them of their last lesson
            to help them.

            Follow up with a discussion to assess answers and vocabulary. Use
            further questioning to ask pupils for an example of a
            socio-economic impact. What could happen as a result of what they
            have observed in the video? The eruption may result in lava flows
            and ash, for example, making visibility poor and leaving people
            injured.
          OVERVIEW
          duration: '10 minutes',
          file_formats: %w(.pdf .doc .mov),
          tags: ['Extra prep'],
          alternatives: ['Pair reading available', 'Worksheet available'],
          extra_requirements: ['Extra prep']
        ),
        OpenStruct.new(
          number: 2,
          activity_type: 'Practical',
          involvement: 'Whole class',
          overview: <<~OVERVIEW,
            Both pupils read an activity sheet explaining the differences
            between active, dormant, and extinct volcanoes.

            Together they should work to correctly label the images of the
            different volcanoes presented.
          OVERVIEW
          duration: '10 minutes',
          file_formats: %w(.pdf .doc .mov),
          tags: ['Extra prep'],
          alternatives: ['Pair reading available', 'Worksheet available'],
          extra_requirements: ['Extra prep']
        )
      ]
    end
  end
end
