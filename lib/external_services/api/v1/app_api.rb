module Api
  module V1
    class AppApi
      include Connection

      API_ENDPOINT = ENV['ASTRAEA_URL']

      attr_accessor :app_params

      def self.query(params = {})
        response = connect.get('cases.json', params.merge(@app_params || {}))
        response.body.fetch('cases', []).map! { |app| App.new(app) }
        response
      end

      def self.save(app)
        connect.post('cases.json', app.to_json)
      end

      def self.update(app_id, app)
        connect.put("cases/#{app_id}.json", app.to_json)
      end

      def self.where(**args)
        app_api = new

        app_api.app_params ||= {}
        app_api.app_params.merge!(args)

        app_api
      end

      def query(params = {})
        response = connect.get('cases.json', params.merge(@app_params || {}))
        response.body.fetch('cases', []).map! { |app| App.new(app) }
        response
      end

      def destroy(params = {})
        connect.delete('cases.json', params.merge(@app_params || {}))
      end

      def where(**args)
        self.app_params ||= {}
        self.app_params.merge!(args)

        self
      end
    end
  end
end
