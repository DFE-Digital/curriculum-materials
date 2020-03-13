module Api
  class NoToken < ActiveRecord::RecordNotFound; end
  class InvalidToken < ActiveRecord::RecordNotFound; end

  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :ensure_token_exists

    rescue_from InvalidToken, with: :invalid_token

  private

    def ensure_token_exists
      if supplied_token.blank?
        raise InvalidToken, "no token supplied"
      end

      return true if matches_master_token?

      # check suppliers

      raise InvalidToken, "bad token #{supplied_token}"
    end

    def supplied_token
      request.headers['HTTP_API_TOKEN']
    end

    def invalid_token(e)
      render(json: { errors: e }, status: :unauthorized)
    end

    def matches_master_token?
      master_token.present? && supplied_token == master_token
    end

    def master_token
      ENV.fetch('API_TOKEN') { nil }
    end
  end
end
