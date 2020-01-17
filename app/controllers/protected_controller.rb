class ProtectedController < ApplicationController
  before_action :ensure_token_exists

  # Delete this once we've got some actual resources that need protection
  def show
    render(json: { authorized: true })
  end

private

  def ensure_token_exists
    unless Teacher.exists?(token: session[:token])
      render(json: { authorized: false }, status: :unauthorized)
    end
  end
end
