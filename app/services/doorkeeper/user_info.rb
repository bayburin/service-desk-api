module Doorkeeper
  class UserInfo < BaseService
    def initialize(doorkeeper_token, auth_center_token_str = '')
      @doorkeeper_token = doorkeeper_token
      @auth_center_token_str = auth_center_token_str

      super
    end

    def run
      @result_token = doorkeeper_token ? auth_center_token.access_token : @auth_center_token_str
      load_user_data

      true
    rescue RuntimeError => e
      ::Rails.logger.error e.inspect.red
      ::Rails.logger.error e.backtrace[0..5].inspect

      false
    end

    protected

    def load_user_data
      uri = URI(AUTH_CENTER_URL + LOGIN_INFO_URN)
      headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{@result_token}"
      }

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri, headers)
        ::Rails.logger.info 'Получение данных о пользователе'
        response = http.request(req)
        @data = process_response(response)
      end
    end
  end
end
