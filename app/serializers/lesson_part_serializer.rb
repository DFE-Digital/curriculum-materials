class LessonPartSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :position

  belongs_to :lesson, serializer: LessonSerializer
end
