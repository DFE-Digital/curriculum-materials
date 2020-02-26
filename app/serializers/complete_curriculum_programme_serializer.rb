class CompleteCurriculumProgrammeSerializer < Blueprinter::Base
  identifier :id

  fields :name, :overview, :benefits
end
