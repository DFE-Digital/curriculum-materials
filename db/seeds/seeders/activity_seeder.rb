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

    def attach_slide_deck(file_path:, preview_path:)
      if api_mode_enabled?
        attach_slide_deck_via_api(file_path, preview_path)
      else
        attach_slide_deck_via_model(file_path, preview_path)
      end
    end

    def attach_teacher_resource(file_path:, preview_path:)
      if api_mode_enabled?
        attach_teacher_resource_via_api(file_path, preview_path)
      else
        attach_teacher_resource_via_model(file_path, preview_path)
      end
    end

    def attach_pupil_resource(file_path:, preview_path:)
      if api_mode_enabled?
        attach_pupil_resource_via_api(file_path, preview_path)
      else
        attach_pupil_resource_via_model(file_path, preview_path)
      end
    end

  private

    def attach_slide_deck_via_api(file_path, preview_path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_slide_deck_path(
            *path_args, @id
          )
        ),
        :slide_deck_resource,
        file_path,
        preview_path
      )
    end

    def attach_teacher_resource_via_api(file_path, preview_path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_teacher_resources_path(
            *path_args, @id
          )
        ),
        :teacher_resource,
        file_path,
        preview_path
      )
    end

    def attach_pupil_resource_via_api(file_path, preview_path)
      save_file_via_api(
        endpoint(
          Rails.application.routes.url_helpers.api_v1_ccp_unit_lesson_lesson_part_activity_pupil_resources_path(
            *path_args, @id
          )
        ),
        :pupil_resource,
        file_path,
        preview_path
      )
    end

    def save_file_via_api(path, param, file_path, preview_path)
      conn = Faraday.new(**faraday_connection_params) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end

      # ActiveStorage will identify the content type, just set it to
      # something generic for the time being
      file_upload = Faraday::UploadIO.new(file_path, 'application/octet-stream')

      body = { "#{param}[file]" => file_upload }

      if preview_path.present?
        preview_upload = Faraday::UploadIO.new(preview_path, 'application/octet-stream')
        body.merge! "#{param}[preview]" => preview_upload
      end

      conn.post(path, body)
    end

    def attach_slide_deck_via_model(file_path, preview_path)
      attach_to_resource @activity.build_slide_deck_resource, file_path, preview_path
    end

    def attach_teacher_resource_via_model(file_path, preview_path)
      attach_to_resource @activity.teacher_resources.new, file_path, preview_path
    end

    def attach_pupil_resource_via_model(file_path, preview_path)
      attach_to_resource @activity.pupil_resources.new, file_path, preview_path
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

    def attach_to_resource(resource, file_path, preview_path)
      resource.file.attach \
        io: File.open(file_path),
        filename: File.basename(file_path)

      if preview_path.present?
        resource.preview.attach \
          io: File.open(preview_path),
          filename: File.basename(preview_path)
      end

      fail ArgumentError, resource.errors.full_messages unless resource.save
    end
  end
end
