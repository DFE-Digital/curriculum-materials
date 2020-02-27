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

    def attach_slide_deck(path)
      if seed_api_url.present?
        attach_slide_deck_via_api(path)
      else
        attach_slide_deck_via_model(path)
      end
    end

    def attach_teacher_resource(path)
      if seed_api_url.present?
        attach_teacher_resource_via_api(path)
      else
        attach_teacher_resource_via_model(path)
      end
    end

    def attach_pupil_resource(path)
      if seed_api_url.present?
        attach_pupil_resource_via_api(path)
      else
        attach_pupil_resource_via_model(path)
      end
    end

  private

    def attach_slide_deck_via_api(path)
    end

    def attach_teacher_resource_via_api(path)
    end

    def attach_pupil_resource_via_api(path)
    end

    def attach_slide_deck_via_model(path)
      fail ArgumentError, @activity.errors.full_messages unless @activity.slide_deck.attach(
        io: File.open(path),
        filename: 'slides.odp'
      )
    end

    def attach_teacher_resource_via_model(path)
      fail ArgumentError, @activity.errors.full_messages unless @activity.teacher_resources.attach(
        io: File.open(path),
        filename: File.basename(path)
      )
    end

    def attach_pupil_resource_via_model(path)
      fail ArgumentError, @activity.errors.full_messages unless @activity.pupil_resources.attach(
        io: File.open(path),
        filename: File.basename(path)
      )
    end

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
      @activity = model_class.create!(attributes.merge(parent)).tap do |obj|
        @id = obj.id
        obj.teaching_methods << teaching_method_objects
      end
    end
  end
end
