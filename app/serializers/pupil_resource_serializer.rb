class PupilResourceSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id
  attributes :url

  belongs_to :activity, serializer: ActivitySerializer

  def url
    # NOTE see note in TeacherResourceSerializer#url
    Rails.application.routes.url_helpers.url_for object
  end
end
