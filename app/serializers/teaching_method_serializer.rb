class TeachingMethodSerializer
  include SimpleAMS::DSL

  adapter SimpleAMS::Adapters::AMS, root: false

  fields :id, :name, :icon, :description

  has_many :activities, serializer: ActivitySerializer
end
