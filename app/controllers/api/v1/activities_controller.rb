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
  end

  def update
  end

private

  def serialize(lesson_part)
    SimpleAMS::Renderer.new(
      lesson_part,
      serializer: ActivitySerializer
    )
  end
end
