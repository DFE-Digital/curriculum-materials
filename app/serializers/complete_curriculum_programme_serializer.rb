class CompleteCurriculumProgrammeSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :name, :overview, :benefits
  generic :include_embedded_data, false

  has_many :units, serializer: UnitSerializer
end
