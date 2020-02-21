module Loader
  class Base
    HOST = "http://localhost:3000"

    def endpoint
      HOST + path
    end

    def save
      resp = Faraday.post(endpoint, payload)

      if resp.status == 201
        @id = JSON.parse(resp.body).dig("id")
      else
        puts "Can't save #{identifier}"
        fail resp.body
      end
    end
  end
end
