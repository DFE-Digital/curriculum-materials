class Api::V1::LessonsController < ApplicationController
  def index
    lessons = Lesson
      .where(unit_id: params[:unit_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        lessons,
        serializer: LessonSerializer,
        included: []
      ).to_json
    )
  end

  def show
    lesson = Lesson
      .eager_load(:unit)
      .where(unit_id: params[:unit_id])
      .find(params[:id])

    render(json: serialize(lesson).to_json)
  end

  def create
    unit = Unit.find_by!(complete_curriculum_programme_id: params[:ccp_id], id: params[:unit_id])
    lesson = unit.lessons.new(lesson_params)

    if lesson.save
      render(json: serialize(lesson).to_json, status: :created)
    else
      render(json: { errors: lesson.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    lesson = Lesson.find_by!(unit_id: params[:unit_id], id: params[:id])

    if lesson.update(lesson_params)
      render(json: serialize(lesson).to_json, status: :ok)
    else
      render(json: { errors: lesson.errors.full_messages }, status: :bad_request)
    end
  end

private

  def lesson_params
    params.require(:lesson).permit(
      :name,
      :summary,
      :position,
      :core_knowledge,
      :previous_knowledge,
      vocabulary: [],
      misconceptions: []
    )
  end

  def serialize(lesson)
    SimpleAMS::Renderer.new(
      lesson,
      serializer: LessonSerializer
    )
  end
end
