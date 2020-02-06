class Api::V1::UnitsController < Api::BaseController
  def index
    units = Unit
      .where(complete_curriculum_programme_id: params[:ccp_id])
      .all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        units,
        serializer: UnitSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    unit = Unit
      .where(complete_curriculum_programme_id: params[:ccp_id])
      .find(params[:id])

    render(json: serialize(unit).to_json)
  end

  def create
    ccp = CompleteCurriculumProgramme.find(params[:ccp_id])
    unit = ccp.units.new(unit_params)

    if unit.save
      render(json: serialize(unit).to_json, status: :created)
    else
      render(json: { errors: unit.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    unit = Unit.find_by!(id: params[:id], complete_curriculum_programme_id: params[:ccp_id])

    if unit.update(unit_params)
      render(json: serialize(unit).to_json, status: :ok)
    else
      render(json: { errors: unit.errors.full_messages }, status: :bad_request)
    end
  end

private

  def unit_params
    params.require(:unit).permit(:name, :overview, :benefits)
  end

  def serialize(unit)
    SimpleAMS::Renderer.new(
      unit,
      serializer: UnitSerializer
    )
  end
end
