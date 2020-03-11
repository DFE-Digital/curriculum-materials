module Seeders
  class LessonSeeder < BaseSeeder
    attr_accessor :id, :name, :misconceptions, :core_knowledge,
                  :summary, :previous_knowledge

    def initialize(ccp, unit, name:, misconceptions:, core_knowledge:, summary:, previous_knowledge:, vocabulary:, position:)
      @ccp  = ccp
      @unit = unit

      @core_knowledge     = core_knowledge
      @misconceptions     = misconceptions
      @name               = name
      @position           = position
      @previous_knowledge = previous_knowledge
      @summary            = summary
      @vocabulary         = vocabulary
    end

    def identifier
      @name
    end

    def model_class
      Lesson
    end

  private

    def parent
      { unit_id: @unit.id }
    end

    def path
      Rails.application.routes.url_helpers.api_v1_ccp_unit_lessons_path(@ccp.id, @unit.id)
    end

    def attributes
      {
        core_knowledge: @core_knowledge,
        misconceptions: @misconceptions,
        name: @name,
        previous_knowledge: @previous_knowledge,
        summary: @summary,
        vocabulary: @vocabulary,
        position: @position
      }
    end

    def payload
      { lesson: attributes }
    end
  end
end
