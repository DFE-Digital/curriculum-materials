class PagesController < ApplicationController
  include HTTPAuth

  PAGES = %w(
    how-to-get-access
  ).freeze

  def show
    page = params[:page]

    if PAGES.include? page
      render template: "pages/#{page}"
    else
      raise ActionController::RoutingError.new 'Not Found'
    end
  end
end
