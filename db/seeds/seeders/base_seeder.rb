module Seeders
  # The BaseSeeder is inherited by all of the model-specific seeder classes. It
  # operates in one of two modes:
  #
  # * API mode - active when the environment variable SEED_API_URL is present
  # * Model mode - active when SEED_API_URL is absent
  class BaseSeeder
    def endpoint(overridden_path = nil)
      seed_api_url + (overridden_path || path)
    end

    def save!
      if api_mode_enabled?
        save_via_api
      else
        save_via_model
      end
    end

    def seed_api_url
      ENV['SEED_API_URL']
    end

  private

    def api_mode_enabled?
      seed_api_url.present?
    end

    def save_via_model
      model_class.create!(attributes.merge(parent)).tap do |obj|
        @id = obj.id
      end
    end

    def save_via_api
      resp = Faraday.post(endpoint, payload)

      if resp.success?
        @id = JSON.parse(resp.body).dig("id")
      else
        puts "Can't save #{identifier}"
        fail resp.body
      end
    end
  end
end
