module Seeders
  class CCPSeeder < BaseSeeder
    attr_accessor :id, :name, :rationale, :guidance, :subject

    def initialize(name:, rationale:, guidance:, subject:, key_stage:)
      @name      = name
      @rationale = rationale
      @guidance  = guidance
      @subject   = subject
      @key_stage = key_stage
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
      { name: @name, rationale: @rationale, guidance: @guidance, key_stage: @key_stage }
    end

    def payload
      { ccp: attributes, subject: @subject }
    end

    def save_via_model
      subject = Subject.find_by(name: @subject)

      @id = model_class.create!(attributes.merge(subject: subject)).id
    end
  end
end
