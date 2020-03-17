module Teachers
  class BaseController < ApplicationController
    include HTTPAuth

    before_action :ensure_token_exists

    def current_teacher
      @current_teacher ||= Teacher.find_by(token: session[:token])
    end

  private

    def ensure_token_exists
      redirect_to('/pages/how-to-get-access') if current_teacher.blank?
    end
  end
end
