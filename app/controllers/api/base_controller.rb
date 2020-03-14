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

      return true if authenticated_against_master_token?

      # return true if ActiveSupport::SecurityUtils.secure_compare(master_token, supplied_token)

      # check suppliers

      raise InvalidToken, "bad token #{supplied_token}"
    end

    def supplied_token
      request.headers['Authorization']
    end

    def invalid_token(e)
      render(json: { errors: e }, status: :unauthorized)
    end

    def authenticated_against_master_token?
      authenticate_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(master_token, token)
      end
    end

    def master_token
      ENV.fetch('API_TOKEN') { nil }
    end
  end
end
