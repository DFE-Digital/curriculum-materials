class UnitSerializer < Blueprinter::Base
  identifier :id

  fields :name, :overview, :benefits, :position, :year
end
