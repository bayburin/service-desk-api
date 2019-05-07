require 'faraday'
require 'faraday_middleware'

module Api
  module V1
    class ApiConnection
      API_ENDPOINT = 'http://api_url_not_defined'.freeze

      def self.conn
        Faraday.new(url: const_get(:API_ENDPOINT)) do |faraday|
          faraday.response :logger, Rails.logger
          faraday.response :json
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
        end
      end
    end
  end
end
