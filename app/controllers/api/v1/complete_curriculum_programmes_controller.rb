class Api::V1::CompleteCurriculumProgrammesController < Api::BaseController
  def index
    ccps = CompleteCurriculumProgramme.all

    render(
      json: SimpleAMS::Renderer::Collection.new(
        ccps,
        serializer: CompleteCurriculumProgrammeSerializer,
        includes: []
      ).to_json
    )
  end

  def show
    ccp = CompleteCurriculumProgramme
      .eager_load(:units)
      .find(params[:id])

    render(json: serialize(ccp).to_json)
  end

  def create
    ccp = CompleteCurriculumProgramme.new(ccp_params)

    if ccp.save
      render(json: serialize(ccp).to_json, status: :created)
    else
      render(json: { errors: ccp.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    ccp = CompleteCurriculumProgramme.find(params[:id])

    if ccp.update(ccp_params)
      render(json: serialize(ccp).to_json, status: :ok)
    else
      render(json: { errors: ccp.errors.full_messages }, status: :bad_request)
    end
  end

private

  def ccp_params
    params.require(:ccp).permit(:name, :overview, :benefits)
  end

  def serialize(ccp)
    SimpleAMS::Renderer.new(
      ccp,
      serializer: CompleteCurriculumProgrammeSerializer
    )
  end
end
