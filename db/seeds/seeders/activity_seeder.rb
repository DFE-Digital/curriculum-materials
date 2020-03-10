module Seeders
  class ActivitySeeder < BaseSeeder
    attr_accessor :id, :name, :overview, :duration, :extra_requirements

    def initialize(ccp, unit, lesson, lesson_part, name:, overview:, duration:, extra_requirements:, teaching_methods: [], default: false)
      @ccp         = ccp
      @unit        = unit
      @lesson      = lesson
      @lesson_part = lesson_part

      @name               = name
      @overview           = overview
      @duration           = duration
      @extra_requirements = extra_requirements
      @default            = default

      @teaching_methods = teaching_methods
    end

    def identifier
      @name
    end

    def attach_slide_deck(path)
      if api_mode_enabled?
        attach_slide_deck_via_api(path)
      else
        attach_slide_deck_via_model(path)
      end
    end

    def attach_teacher_resource(path)
      if api_mode_enabled?
        attach_teacher_resource_via_api(path)
      else
        attach_teacher_resource_via_model(path)
      end
    end

    def attach_pupil_resource(path)
      if api_mode_enabled?
        attach_pupil_resource_via_api(path)
      else
        attach_pupil_resource_via_model(path)
      end
    end

  private

    def attach_slide_deck_via_api(path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_slide_deck_path(
            *path_args, @id
          )
        ),
        :slide_deck,
        path
      )
    end

    def attach_teacher_resource_via_api(path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_teacher_resources_path(
            *path_args, @id
          )
        ),
        :teacher_resource,
        path
      )
    end

    def attach_pupil_resource_via_api(path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_pupil_resources_path(
            *path_args, @id
          )
        ),
        :pupil_resource,
        path
      )
    end

    def save_file_via_api(path, param, file)
      conn = Faraday.new(url: path) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end

      # ActiveStorage will identify the content type, just set it to
      # something generic for the time being
      upload = Faraday::UploadIO.new(file, 'application/octet-stream')

      conn.post(path, param => upload)
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
      Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activities_path(*path_args)
    end

    def path_args
      [@ccp.id, @unit.id, @lesson.id, @lesson_part.id]
    end

    def attributes
      {
        name: @name,
        overview: @overview,
        duration: @duration,
        extra_requirements: @extra_requirements,
        default: @default
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
