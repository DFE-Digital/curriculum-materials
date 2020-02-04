module Teachers
  class SessionsController < BaseController
    skip_before_action :ensure_token_exists

    def create
      if Teacher.exists?(token: params[:token])
        session[:token] = params[:token]

        redirect_to root_path
      else
        Rails.logger.error("invalid token #{params[:token]}")

        render json: { failed: 'bad token' }, status: :bad_request
      end
    end

    def show; end

    def destroy
      session.clear

      redirect_to teachers_logged_out_path
    end
  end
end
