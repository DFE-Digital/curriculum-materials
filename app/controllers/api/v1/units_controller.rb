class Api::V1::UnitsController < ApplicationController
  def index
    @units = Unit
      .where(complete_curriculum_programme_id: params[:ccp_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        @units,
        serializer: UnitSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    @unit = Unit
      .where(complete_curriculum_programme_id: params[:ccp_id])
      .find(params[:id])

    render(
      json: SimpleAMS::Renderer.new(
        @unit,
        serializer: UnitSerializer
      ).to_json
    )
  end
end
