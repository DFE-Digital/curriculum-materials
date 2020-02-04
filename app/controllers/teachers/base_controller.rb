module Teachers
  class BaseController < ApplicationController
    before_action :ensure_token_exists

  private

    def ensure_token_exists
      teacher = Teacher.find_by(token: session[:token])

      if teacher.present?
        @current_teacher = teacher
      else
        redirect_to '/pages/how-to-get-access'
      end
    end
  end
end
