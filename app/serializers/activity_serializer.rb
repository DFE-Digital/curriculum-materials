class ActivitySerializer < Blueprinter::Base
  identifier :id

  fields :name, :overview, :duration, :default, :extra_requirements
end
