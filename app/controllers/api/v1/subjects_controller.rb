class Api::V1::SubjectsController < Api::BaseController
  def index
    render(json: serialize(Subject.all))
  end

  def show
    subject = Subject.find(params[:id])

    render(json: serialize(subject))
  rescue ActiveRecord::RecordNotFound
    render(json: { errors: %(Subject #{params[:id]} not found) }, status: :not_found)
  end

private

  def serialize(data)
    SubjectSerializer.render(data)
  end
end
