class Api::V1::ActivitiesController < Api::BaseController
  def index
    activities = Activity
      .where(lesson_part_id: params[:lesson_part_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        activities,
        serializer: ActivitySerializer,
        includes: []
      ).to_json
    )
  end

  def show
    activity = Activity
      .where(lesson_part_id: params[:lesson_part_id])
      .find(params[:id])

    render(json: serialize(activity).to_json)
  end

  def create
    lesson_part = LessonPart.find_by!(lesson_id: params[:lesson_id], id: params[:lesson_part_id])
    activity = lesson_part.activities.new(activity_params)

    Activity.transaction do
      if activity.save && assign_teaching_methods(activity, teaching_methods_from_params)
        render(json: serialize(activity).to_json, status: :created)
      else
        render(json: { errors: activity.errors.full_messages }, status: :bad_request)
      end
    end
  end

  def update
    activity = Activity.find_by!(lesson_part_id: params[:lesson_part_id], id: params[:id])

    Activity.transaction do
      if activity.update(activity_params) && assign_teaching_methods(activity, teaching_methods_from_params)
        render(json: serialize(activity).to_json, status: :ok)
      else
        render(json: { errors: activity.errors.full_messages }, status: :bad_request)
      end
    end
  end

private

  def activity_params
    params.require(:activity).permit(:name, :overview, :duration, :default, extra_requirements: [])
  end

  def teaching_methods_from_params
    TeachingMethod.where(name: params.dig('teaching_methods'))
  end

  def assign_teaching_methods(activity, teaching_methods)
    activity.teaching_methods = teaching_methods
  end

  def serialize(lesson_part)
    SimpleAMS::Renderer.new(
      lesson_part,
      serializer: ActivitySerializer,
      includes: [:teaching_methods]
    )
  end
end
