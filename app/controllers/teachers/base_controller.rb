module Teachers
  class BaseController < ApplicationController
    before_action :ensure_token_exists

  private

    def ensure_token_exists
      unless Teacher.exists?(token: session[:token])
        render(json: { authorized: false }, status: :unauthorized)
      end
    end
  end
end
