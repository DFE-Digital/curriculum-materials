class Api::V1::PupilResourcesController < Api::BaseController
  def index
    activity = Activity.find_by! id: params[:activity_id]

    pupil_resources = activity.pupil_resources

    render json: SimpleAMS::Renderer::Collection.new(
      pupil_resources,
      serializer: PupilResourceSerializer,
      includes: []
    ).to_json
  end

  def create
    activity = Activity.find_by! id: params[:activity_id]

    if activity.pupil_resources.attach pupil_resource_params
      head :created
    else
      render json: { errors: activity.errors.full_messages }, status: :bad_request
    end
  end

private

  def pupil_resource_params
    params.require :pupil_resource
  end
end
