module Api
  module V1
    module Employees
      class UserRequestChanger
        def self.request(type, params)
          case type
          when :exact
            EmployeeApi.load_users(params[:tns].uniq)
          when :like
            EmployeeApi.load_users_like(params[:field], params[:term])
          end
        end
      end
    end
  end
end
