class Api::V1::LessonPartsController < Api::BaseController
  def index
    lessons_parts = LessonPart
      .where(lesson_id: params[:lesson_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        lessons_parts,
        serializer: LessonPartSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    lesson_part = LessonPart
      .eager_load(:lesson)
      .where(lesson_id: params[:lesson_id])
      .find(params[:id])

    render(json: serialize(lesson_part).to_json)
  end

  def create
    lesson = Lesson.find_by!(unit_id: params[:unit_id], id: params[:lesson_id])
    lesson_part = lesson.lesson_parts.new(lesson_part_params)

    if lesson_part.save
      render(json: serialize(lesson_part).to_json, status: :created)
    else
      render(json: { errors: lesson_part.errors.full_messages }, status: :bad_request)
    end
  end

  def update
  end

private

  def lesson_part_params
    params.require(:lesson_part).permit(:position)
  end


  def serialize(lesson_part)
    SimpleAMS::Renderer.new(
      lesson_part,
      serializer: LessonPartSerializer
    )
  end
end
