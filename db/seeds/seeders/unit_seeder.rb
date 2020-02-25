module Seeders
  class UnitSeeder < BaseSeeder
    attr_accessor :id, :name, :overview, :benefits, :position

    def initialize(ccp, name:, overview:, benefits:, position:)
      @ccp = ccp

      @name     = name
      @overview = overview
      @benefits = benefits
      @position = position
    end

    def identifier
      @name
    end

    def model_class
      Unit
    end

  private

    def parent
      { complete_curriculum_programme_id: @ccp.id }
    end

    def path
      Rails.application.routes.url_helpers.api_v1_ccp_units_path(@ccp.id)
    end

    def attributes
      { name: @name, overview: @overview, benefits: @benefits, position: @position }
    end

    def payload
      { unit: attributes }
    end
  end
end
