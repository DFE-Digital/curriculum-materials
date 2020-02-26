class Api::V1::ActivitiesController < Api::BaseController
  def index
    activities = Activity
      .where(lesson_part_id: params[:lesson_part_id])
      .all

    render(json: serialize(activities))
  end

  def show
    activity = Activity
      .where(lesson_part_id: params[:lesson_part_id])
      .find(params[:id])

    render(json: serialize(activity))
  end

  def create
    lesson_part = LessonPart.find_by!(lesson_id: params[:lesson_id], id: params[:lesson_part_id])
    activity = lesson_part.activities.new(activity_params)

    if activity.save
      render(json: serialize(activity), status: :created)
    else
      render(json: { errors: activity.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    activity = Activity.find_by!(lesson_part_id: params[:lesson_part_id], id: params[:id])

    if activity.update(activity_params)
      render(json: serialize(activity), status: :ok)
    else
      render(json: { errors: activity.errors.full_messages }, status: :bad_request)
    end
  end

private

  def activity_params
    params.require(:activity).permit(:name, :overview, :duration, :default, extra_requirements: [])
  end

  def serialize(data)
    ActivitySerializer.render(data)
  end
end
