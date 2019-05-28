module Api
  module V1
    class CaseApi
      include Connection

      API_ENDPOINT = ENV['ASTRAEA_URL']

      attr_accessor :case_params

      def self.query(params = {})
        response = connect.get('cases.json', params.merge(@case_params || {}))
        response.body.fetch('cases', []).map! { |kase| Case.new(kase) }
        response
      end

      def self.save(kase)
        connect.post('cases.json', kase.to_json)
      end

      def self.where(**args)
        case_api = new

        case_api.case_params ||= {}
        case_api.case_params.merge!(args)

        case_api
      end

      def query(params = {})
        response = connect.get('cases.json', params.merge(@case_params || {}))
        response.body.fetch('cases', []).map! { |kase| Case.new(kase) }
        response
      end

      def destroy(params = {})
        connect.delete('cases.json', params.merge(@case_params || {}))
      end

      def where(**args)
        self.case_params ||= {}
        self.case_params.merge!(args)

        self
      end
    end
  end
end
