class UnitSerializer < Blueprinter::Base
  identifier :id

  fields :name, :summary, :rationale, :guidance, :position, :year
end
