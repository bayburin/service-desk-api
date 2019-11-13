module Api
  module V1
    module Employees
      class Employee
        STOP_COUNTER = 2

        def initialize
          @authorize = Authorize.new
          @counter = 0
        end

        def load_users(tn)
          if @counter == STOP_COUNTER
            @counter = 0
            return nil
          end

          @counter += 1
          @authorize.token || @authorize.authorize
          response = EmployeeApi.load_users(tn)
          if response.success?
            @counter = 0
            response.body
          else
            @authorize.clear
            load_users(tn)
          end
        end
      end
    end
  end
end
