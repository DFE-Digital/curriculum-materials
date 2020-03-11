class CompleteCurriculumProgrammeSerializer < Blueprinter::Base
  identifier :id

  fields :name, :rationale, :key_stage

  field(:subject) { |ccp| ccp.subject.name }
end
