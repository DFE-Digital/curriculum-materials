module Teachers
  class LoggedOutController < BaseController
    skip_before_action :ensure_token_exists

    def show
      @token = params[:token]
    end
  end
end
