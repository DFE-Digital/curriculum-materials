module Seeders
  class CCPSeeder < BaseSeeder
    attr_accessor :id, :name, :overview, :benefits

    def initialize(name:, rationale:)
      @name      = name
      @rationale = rationale
    end

    def identifier
      @name
    end

    def model_class
      CompleteCurriculumProgramme
    end

  private

    def parent
      {}
    end

    def path
      Rails.application.routes.url_helpers.api_v1_ccps_path
    end

    def attributes
      { name: @name, rationale: @rationale }
    end

    def payload
      { ccp: attributes }
    end
  end
end
