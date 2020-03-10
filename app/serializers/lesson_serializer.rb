class LessonSerializer < Blueprinter::Base
  identifier :id

  fields :name, :summary, :position, :core_knowledge,
         :previous_knowledge, :vocabulary, :misconceptions
end
