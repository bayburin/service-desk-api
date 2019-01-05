module Doorkeeper
  class BaseService < ApplicationService
    AUTH_CENTER_URL = 'https://auth-center.iss-reshetnev.ru/'.freeze
    TOKEN_URN = 'oauth/token'.freeze
    LOGIN_INFO_URN = 'api/module/main/login_info'.freeze

    protected

    def process_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      when Net::HTTPUnauthorized
        errors.add(:base, :incorrent_username_or_password)
        error[:status] = 401

        raise "Ошибка: #{response.inspect}"
      when Net::HTTPServerError
        errors.add(:base, :authorization_server_error)
        error[:status] = 500

        raise "Ошибка: #{response.inspect}"
      else
        errors.add(:base, :unprocessable_entity)
        error[:status] = 422

        raise "Ошибка: #{response.inspect}"
      end
    end
  end
end
