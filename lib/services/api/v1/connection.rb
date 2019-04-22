require 'faraday'

module Api
  module V1
    class Connection
      API_ENDPOINT = 'http://api_url_not_defined'.freeze

      def self.conn
        Faraday.new(url: const_get(:API_ENDPOINT)) do |faraday|
          faraday.response :logger, Rails.logger
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
        end
      end
    end
  end
end
