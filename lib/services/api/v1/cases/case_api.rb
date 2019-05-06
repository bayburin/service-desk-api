module Api
  module V1
    module Cases
      class CaseApi
        attr_accessor :case_params

        def self.query(params = {})
          response = Api::V1::Cases::Request.get('cases.json', params.merge(@case_params || {}))
          response.fetch('cases', []).map! { |kase| Case.new(kase) }
          response
        end

        def self.save(kase)
          response = Api::V1::Cases::Request.post('cases.json', kase)
          return unless response

          kase.case_id = response['case_id']
          kase
        end

        def self.where(**args)
          case_api = new

          case_api.case_params ||= {}
          case_api.case_params.merge!(args)

          case_api
        end

        def query(params = {})
          response = Api::V1::Cases::Request.get('cases.json', params.merge(@case_params || {}))
          response.fetch('cases', []).map! { |kase| Case.new(kase) }
          response
        end

        def where(**args)
          self.case_params ||= {}
          self.case_params.merge!(args)

          self
        end
      end
    end
  end
end
