class Api::V1::TeachingMethodsController < Api::BaseController
  def index
    render(json: serialize(TeachingMethod.all))
  end

  def show
    teaching_method = TeachingMethod.find(params[:id])

    render(json: serialize(teaching_method))
  rescue ActiveRecord::RecordNotFound
    render(json: { errors: %(Teaching method #{params[:id]} not found) }, status: :not_found)
  end

private

  def serialize(data)
    TeachingMethodSerializer.render(data)
  end
end
