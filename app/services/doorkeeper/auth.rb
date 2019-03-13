module Doorkeeper
  class Auth < BaseService
    def initialize(username, password)
      @username = username
      @password = password

      super
    end

    def run
      load_token
      load_user_data

      true
    rescue RuntimeError => e
      ::Rails.logger.error e.inspect.red
      ::Rails.logger.error e.backtrace[0..5].inspect

      false
    end

    def load_token
      uri = URI(AUTH_CENTER_URL + TOKEN_URN)
      headers = { 'Content-Type': 'application/json' }

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri, headers)
        req.body = {
          grant_type: 'password',
          username: @username,
          password: @password,
          client_id: 9,
          client_secret: 'xxeHbgcl3PHqdu83OT3TuE6WKWleDF6IhmbWgwxt',
          scope: 'test_api'
        }.to_json

        ::Rails.logger.info 'Проверка связки логин/пароль и получение токена'
        response = http.request(req)
        @token_data = process_response(response)
      end
    end

    def load_user_data
      user_info = UserInfo.new(nil, @token_data['access_token'])
      raise 'Не удалось получить данные пользователя' unless user_info.run

      @data = user_info.data
      AuthCenterToken.create!(@token_data.merge(resource_owner_id: data['tn']))
    end
  end
end
