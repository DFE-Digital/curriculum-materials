class Api::V1::TeachingMethodsController < Api::BaseController
  def index
    render(
      json: SimpleAMS::Renderer::Collection.new(
        TeachingMethod.all,
        serializer: TeachingMethodSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    teaching_method = TeachingMethod.find(params[:id])

    render(
      json: SimpleAMS::Renderer.new(
        teaching_method,
        serializer: TeachingMethodSerializer,
        includes: []
      ).to_json
    )
  rescue ActiveRecord::RecordNotFound
    render(json: { errors: %(Teaching method #{params[:id]} not found) }, status: :not_found)
  end
end
