class ApplicationController < ActionController::Base
  include HTTPAuth

  before_action :set_raven_context

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
