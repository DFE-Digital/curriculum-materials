class LessonSerializer < Blueprinter::Base
  identifier :id

  fields :name, :position, :core_knowledge_for_pupils,
         :core_knowledge_for_teachers, :previous_knowledge,
         :vocabulary, :misconceptions, :learning_objective
end
