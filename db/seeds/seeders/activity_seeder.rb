module Seeders
  class ActivitySeeder < BaseSeeder
    attr_accessor :id, :name, :overview, :duration, :extra_requirements

    def initialize(ccp, unit, lesson, lesson_part, name:, overview:, duration:, extra_requirements:, teaching_methods: [])
      @ccp         = ccp
      @unit        = unit
      @lesson      = lesson
      @lesson_part = lesson_part

      @name               = name
      @overview           = overview
      @duration           = duration
      @extra_requirements = extra_requirements

      @teaching_methods = teaching_methods
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
      { activity: attributes, teaching_methods: @teaching_methods }
    end

    def teaching_method_objects
      TeachingMethod.where(name: @teaching_methods)
    end

    def save_via_model
      model_class.create!(attributes.merge(parent)).tap do |obj|
        @id = obj.id
        obj.teaching_methods << teaching_method_objects
      end
    end
  end
end
