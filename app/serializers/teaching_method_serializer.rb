class TeachingMethodSerializer < Blueprinter::Base
  identifier :id

  fields :name, :icon, :description
end
