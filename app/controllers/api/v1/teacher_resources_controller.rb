class Api::V1::TeacherResourcesController < Api::BaseController
  def index
    render json: TeacherResourceSerializer.render(teacher_resources)
  end

  def create
    teacher_resource = teacher_resources.new teacher_resource_params
    if teacher_resource.save
      head :created
    else
      render json: { errors: teacher_resource.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    teacher_resource = teacher_resources.find params[:id]
    teacher_resource.destroy!
    head :no_content
  end

private

  def teacher_resources
    @teacher_resources ||= activity.temp_teacher_resources
  end

  def activity
    @activity ||= Activity.find params[:activity_id]
  end

  def teacher_resource_params
    params.require(:teacher_resource).permit :file, :preview
  end
end
