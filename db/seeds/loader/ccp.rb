module Loader
  class CCP < Base
    attr_accessor :id, :name, :overview, :benefits

    def initialize(name:, overview:, benefits:)
      @name     = name
      @overview = overview
      @benefits = benefits
    end

    def identifier
      @name
    end

  private

    def path
      Rails.application.routes.url_helpers.api_v1_ccps_path
    end

    def attributes
      { name: @name, overview: @overview, benefits: @benefits }
    end

    def payload
      { ccp: attributes }
    end
  end
end
