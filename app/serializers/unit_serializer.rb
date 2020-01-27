class UnitSerializer
  include SimpleAMS::DSL

  type :unit
  collection :units

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :name, :overview, :benefits

  belongs_to :complete_curriculum_programme, serializer: CompleteCurriculumProgrammeSerializer
  has_many :lessons, serializer: LessonSerializer
end
