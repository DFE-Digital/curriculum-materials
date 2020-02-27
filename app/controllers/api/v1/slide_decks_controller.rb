class Api::V1::SlideDecksController < Api::BaseController
  def show
    render json: SlideDeckSerializer.render(activity.slide_deck)
  end

  def create
    if activity.slide_deck.attach slide_deck_params
      head :created
    else
      render json: { errors: activity.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    activity.slide_deck.purge
    head :no_content
  end

private

  def activity
    @activity ||= Activity.find params[:activity_id]
  end

  def slide_deck_params
    params.require :slide_deck
  end
end
