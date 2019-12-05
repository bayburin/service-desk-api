module Api
  module V1
    module Employees
      class Authorize
        TOKEN_NAME = 'employee_token'.freeze

        def token
          ReadCache.redis.get(TOKEN_NAME)
        end

        def token=(new_token)
          ReadCache.redis.set(TOKEN_NAME, new_token)
        end

        def authorize
          Rails.logger.debug { 'Авторизация на сервере НСИ' }
          response = EmployeeApi.login
          self.token = response.body['token'] if response.success?
        end

        def clear
          ReadCache.redis.del(TOKEN_NAME)
        end
      end
    end
  end
end
