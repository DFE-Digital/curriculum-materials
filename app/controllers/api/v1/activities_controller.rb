class Api::V1::ActivitiesController < Api::BaseController
  class TeachingMethodNotFound < ActiveRecord::RecordNotFound; end

  rescue_from TeachingMethodNotFound, with: :teaching_method_not_found

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

    Activity.transaction do
      if activity.save && set_teaching_methods(activity)
        render(json: serialize(activity), status: :created)
      else
        render(json: { errors: activity.errors.full_messages }, status: :bad_request)
      end
    end
  end

  def update
    activity = Activity.find_by!(lesson_part_id: params[:lesson_part_id], id: params[:id])

    Activity.transaction do
      if activity.update(activity_params) && set_teaching_methods(activity)
        render(json: serialize(activity), status: :ok)
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
    teaching_method_params = params.dig(:teaching_methods)

    return if teaching_method_params.nil?

    TeachingMethod.where(name: teaching_method_params).tap do |teaching_methods|
      diff = teaching_method_params.difference(teaching_methods.map(&:name))

      fail TeachingMethodNotFound, diff.to_sentence unless diff.empty?
    end
  end

  def set_teaching_methods(activity)
    teaching_methods = teaching_methods_from_params

    if teaching_methods.nil?
      true # no params passed, don't touch the teaching methods
    else
      activity.teaching_methods = teaching_methods
    end
  end

  def serialize(data)
    ActivitySerializer.render(data)
  end

  def teaching_method_not_found(e)
    render(json: { errors: %(Invalid teaching method: #{e.message}) }, status: :bad_request)
  end
end
