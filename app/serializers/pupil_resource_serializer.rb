class PupilResourceSerializer < Blueprinter::Base
  identifier :id

  field :url do |object|
    Rails.application.routes.url_helpers.url_for object
  end
end
