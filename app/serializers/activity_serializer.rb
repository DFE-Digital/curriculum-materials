class ActivitySerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :overview, :duration, :extra_requirements

  belongs_to :lesson_part, serializer: LessonPartSerializer
end
