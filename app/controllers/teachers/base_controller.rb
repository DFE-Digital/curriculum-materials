module Teachers
  class BaseController < ApplicationController
    before_action :ensure_token_exists

  private

    def ensure_token_exists
      unless Teacher.exists?(token: session[:token])
        redirect_to '/pages/how-to-get-access'
      end
    end
  end
end
