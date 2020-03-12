class PupilResourceSerializer < Blueprinter::Base
  identifier :id

  field :file_url do |object|
    if object.file.attached?
      Rails.application.routes.url_helpers.url_for object.file
    end
  end

  field :preview_url do |object|
    if object.preview.attached?
      Rails.application.routes.url_helpers.url_for object.preview
    end
  end
end
