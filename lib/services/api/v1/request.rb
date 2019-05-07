module Api
  module V1
    class Request < ApiConnection
      class << self
        def get(resource_path, params = {})
          conn.get(resource_path.to_s, params)
        end

        def post(resource_path, params = {})
          conn.post(resource_path, params.to_json)
        end

        def delete(resource_path, params = {})
          conn.delete(resource_path, params)
        end
      end
    end
  end
end
