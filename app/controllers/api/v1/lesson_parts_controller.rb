class Api::V1::LessonPartsController < Api::BaseController
  def index
    lesson_parts = LessonPart
      .where(lesson_id: params[:lesson_id])
      .all

    render(json: serialize(lesson_parts))
  end

  def show
    lesson_part = LessonPart
      .eager_load(:lesson)
      .where(lesson_id: params[:lesson_id])
      .find(params[:id])

    render(json: serialize(lesson_part))
  end

  def create
    lesson = Lesson.find_by!(unit_id: params[:unit_id], id: params[:lesson_id])
    lesson_part = lesson.lesson_parts.new(lesson_part_params)

    if lesson_part.save
      render(json: serialize(lesson_part), status: :created)
    else
      render(json: { errors: lesson_part.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    lesson_part = LessonPart.find_by!(lesson_id: params[:lesson_id], id: params[:id])

    if lesson_part.update(lesson_part_params)
      render(json: serialize(lesson_part), status: :ok)
    else
      render(json: { errors: lesson_part.errors.full_messages }, status: :bad_request)
    end
  end

private

  def lesson_part_params
    params.require(:lesson_part).permit(:position)
  end

  def serialize(data)
    LessonPartSerializer.render(data)
  end
end
