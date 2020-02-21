module Loader
  class LessonPart < Base
    attr_accessor :id, :position

    def initialize(ccp, unit, lesson, position:)
      @ccp    = ccp
      @unit   = unit
      @lesson = lesson

      @position = position
    end

    def identifier
      "Lesson part #{position}"
    end

  private

    def path
      Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_parts_path(@ccp.id, @unit.id, @lesson.id)
    end

    def attributes
      { position: position }
    end

    def payload
      { lesson_part: attributes }
    end
  end
end
