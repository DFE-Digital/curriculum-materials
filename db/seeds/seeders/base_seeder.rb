module Seeders
  class BaseSeeder
    def endpoint
      seed_api_url + path
    end

    def save
      if seed_api_url.present?
        save_via_api
      else
        save_via_model
      end
    end

    def seed_api_url
      ENV['SEED_API_URL']
    end

  private

    def save_via_model
      model_class.create(attributes).tap do |obj|
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
