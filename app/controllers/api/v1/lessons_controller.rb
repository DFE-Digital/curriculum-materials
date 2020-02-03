class Api::V1::LessonsController < ApplicationController
  def index
    @lessons = Lesson
      .where(unit_id: params[:unit_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        @lessons,
        serializer: LessonSerializer,
        included: []
      ).to_json
    )
  end

  def show
    @lesson = Lesson
      .eager_load(:unit)
      .where(unit_id: params[:unit_id])
      .find(params[:id])

    render(
      json: SimpleAMS::Renderer.new(
        @lesson,
        serializer: LessonSerializer
      ).to_json
    )
  end
end
