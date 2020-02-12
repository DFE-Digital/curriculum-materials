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
end
