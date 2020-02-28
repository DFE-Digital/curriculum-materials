class Api::V1::PupilResourcesController < Api::BaseController
  def index
    render json: PupilResourceSerializer.render(pupil_resources.blobs)
  end

  def create
    if pupil_resources.attach pupil_resource_params
      head :created
    else
      render json: { errors: activity.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    pupil_resource = pupil_resources.find params[:id]
    pupil_resource.purge
    head :no_content
  end

private

  def pupil_resources
    @pupil_resources ||= activity.pupil_resources
  end

  def activity
    @activity ||= Activity.with_attached_pupil_resources.find params[:activity_id]
  end

  def pupil_resource_params
    params.require :pupil_resource
  end
end
