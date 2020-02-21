class Api::V1::TeacherResourcesController < Api::BaseController
  def create
    activity = Activity.find_by! id: params[:activity_id]

    if activity.teacher_resources.attach teacher_resource_params
      head :created
    else
      render json: { errors: activity.errors.full_messages }, status: :bad_request
    end
  end

private

  def teacher_resource_params
    params.require :teacher_resource
  end
end
