module Seeders
  class LessonSeeder < BaseSeeder
    attr_accessor :id, :name, :misconceptions, :core_knowledge,
                  :summary, :previous_knowledge

    def initialize(ccp, unit, name:, misconceptions:, core_knowledge:, summary:, previous_knowledge:)
      @ccp  = ccp
      @unit = unit

      @name               = name
      @misconceptions     = misconceptions
      @core_knowledge     = core_knowledge
      @summary            = summary
      @previous_knowledge = previous_knowledge
    end

    def identifier
      @name
    end

    def model_class
      Lesson
    end

  private

    def path
      Rails.application.routes.url_helpers.api_v1_ccp_unit_lessons_path(@ccp.id, @unit.id)
    end

    def attributes
      {
        core_knowledge: @core_knowledge,
        misconceptions: @misconceptions,
        name: @name,
        previous_knowledge: @previous_knowledge,
        summary: @summary
      }
    end

    def payload
      { lesson: attributes }
    end
  end
end
