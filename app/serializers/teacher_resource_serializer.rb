class TeacherResourceSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id
  attributes :url

  belongs_to :activity, serializer: ActivitySerializer

  def url
    # NOTE there is a bug in the SimpleAMS library which causes `object` to be
    # cached when itterating through a collection.
    # This causes our index endpoint for TeacherResources to return the same
    # url for all TeacherResources.
    Rails.application.routes.url_helpers.url_for object
  end
end
