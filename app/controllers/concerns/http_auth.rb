module HTTPAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  def http_authenticate
    return true unless Rails.env.staging?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('HTTP_AUTH_USER') && password == ENV.fetch('HTTP_AUTH_PASSWORD')
    end
  end
end
