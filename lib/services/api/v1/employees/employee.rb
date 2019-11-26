module Api
  module V1
    module Employees
      class Employee
        STOP_COUNTER = 2

        def initialize(type)
          @type = type
          @authorize = Authorize.new
          @counter = 0
        end

        def load_users(params)
          if @counter == STOP_COUNTER
            @counter = 0
            return nil
          end

          @counter += 1
          @authorize.token || @authorize.authorize
          response = UserRequestChanger.request(@type, params)
          if response.success?
            @counter = 0
            response.body
          else
            @authorize.clear
            load_users(params)
          end
        end
      end
    end
  end
end
