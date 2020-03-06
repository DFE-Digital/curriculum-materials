class CompleteCurriculumProgrammeSerializer < Blueprinter::Base
  identifier :id

  fields :name, :rationale, :key_stage
end
