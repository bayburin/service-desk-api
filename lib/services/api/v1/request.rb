module Api
  module V1
    class Request < Connection
      # FIXME: Никак не обрабатываются ошибки
      class << self
        def get(resource_path, params = {})
          response = conn.get(resource_path.to_s, params)
          Oj.load(response.body)
        end

        def post(resource_path, params = {})
          response = conn.post(resource_path, params.to_json)
          Oj.load(response.body)
        end
      end
    end
  end
end
