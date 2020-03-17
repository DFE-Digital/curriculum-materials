class Api::V1::PupilResourcesController < Api::BaseController
  def index
    render json: PupilResourceSerializer.render(pupil_resources)
  end

  def create
    pupil_resource = pupil_resources.new pupil_resource_params
    if pupil_resource.save
      head :created
    else
      render json: { errors: pupil_resource.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    pupil_resource = pupil_resources.find params[:id]
    pupil_resource.destroy!
    head :no_content
  end

private

  def pupil_resources
    @pupil_resources ||= activity.pupil_resources
  end

  def activity
    @activity ||= Activity.find params[:activity_id]
  end

  def pupil_resource_params
    params.require(:pupil_resource).permit :file, :preview
  end
end
