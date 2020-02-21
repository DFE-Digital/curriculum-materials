module Seeders
  class ActivitySeeder < BaseSeeder
    attr_accessor :id, :name, :overview, :duration, :extra_requirements

    def initialize(ccp, unit, lesson, lesson_part, name:, overview:, duration:, extra_requirements:)
      @ccp         = ccp
      @unit        = unit
      @lesson      = lesson
      @lesson_part = lesson_part

      @name               = name
      @overview           = overview
      @duration           = duration
      @extra_requirements = extra_requirements
    end

    def identifier
      @name
    end

  private

    def parent
      { lesson_part_id: @lesson_part.id }
    end

    def model_class
      Activity
    end

    def path
      Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activities_path(
        @ccp.id,
        @unit.id,
        @lesson.id,
        @lesson_part.id
      )
    end

    def attributes
      {
        name: @name,
        overview: @overview,
        duration: @duration,
        extra_requirements: @extra_requirements,

        default: false
      }
    end

    def payload
      { activity: attributes }
    end
  end
end
