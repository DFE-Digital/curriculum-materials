class CompleteCurriculumProgrammeSerializer < Blueprinter::Base
  identifier :id

  fields :name, :rationale
end
