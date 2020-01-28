class LessonSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :name, :summary, :position, :core_knowledge,
         :previous_knowledge, :vocabulary, :misconceptions

  belongs_to :unit, serializer: UnitSerializer
end
