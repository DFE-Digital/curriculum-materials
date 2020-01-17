class SessionsController < ApplicationController
  def create
    if Teacher.exists?(token: params[:token])
      session[:token] = params[:token]

      redirect_to root_path
    else
      Rails.logger.error("invalid token #{params[:token]}")

      render json: { failed: 'bad token' }, status: :bad_request
    end
  end

  def destroy
    session.clear

    redirect_to root_path
  end
end
