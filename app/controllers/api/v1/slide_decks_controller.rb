class Api::V1::SlideDecksController < Api::BaseController
  def show
    render json: SlideDeckResourceSerializer.render(activity.temp_slide_deck_resource)
  end

  def create
    slide_deck_resource = activity.build_temp_slide_deck_resource slide_deck_params
    if slide_deck_resource.save
      head :created
    else
      render json: { errors: slide_deck_resource.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    activity.temp_slide_deck_resource.destroy!
    head :no_content
  end

private

  def activity
    @activity ||= Activity.find params[:activity_id]
  end

  def slide_deck_params
    params.require(:slide_deck_resource).permit :file, :preview
  end
end
