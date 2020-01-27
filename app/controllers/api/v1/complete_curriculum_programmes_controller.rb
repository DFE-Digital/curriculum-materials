class Api::V1::CompleteCurriculumProgrammesController < ApplicationController
  def index
    @ccps = CompleteCurriculumProgramme.all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        @ccps,
        serializer: CompleteCurriculumProgrammeSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    @ccp = CompleteCurriculumProgramme
      .eager_load(:units)
      .find(params[:id])

    render(
      json: SimpleAMS::Renderer.new(
        @ccp,
        serializer: CompleteCurriculumProgrammeSerializer
      ).to_json
    )
  end
end
