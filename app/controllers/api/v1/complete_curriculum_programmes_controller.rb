class Api::V1::CompleteCurriculumProgrammesController < Api::BaseController
  def index
    ccps = CompleteCurriculumProgramme.all

    render(json: serialize(ccps))
  end

  def show
    ccp = CompleteCurriculumProgramme
      .eager_load(:units)
      .find(params[:id])

    render(json: serialize(ccp))
  end

  def create
    ccp = CompleteCurriculumProgramme.new(ccp_params)

    if ccp.save
      render(json: serialize(ccp), status: :created)
    else
      render(json: { errors: ccp.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    ccp = CompleteCurriculumProgramme.find(params[:id])

    if ccp.update(ccp_params)
      render(json: serialize(ccp), status: :ok)
    else
      render(json: { errors: ccp.errors.full_messages }, status: :bad_request)
    end
  end

private

  def ccp_params
    params.require(:ccp).permit(:name, :overview, :benefits)
  end

  def serialize(data)
    CompleteCurriculumProgrammeSerializer.render(data)
  end
end
