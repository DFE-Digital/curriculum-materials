class ActivitySerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :name, :overview, :duration, :default, :extra_requirements

  belongs_to :lesson_part, serializer: LessonPartSerializer
end
