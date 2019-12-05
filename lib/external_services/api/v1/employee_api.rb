module Api
  module V1
    class EmployeeApi
      include Connection

      API_ENDPOINT = ENV['EMPLOYEE_DATABASE_URL']

      def self.login
        connect.post('login') do |req|
          req.headers['X-Auth-Username'] = ENV['EMPLOYEE_DATABASE_USERNAME']
          req.headers['X-Auth-Password'] = ENV['EMPLOYEE_DATABASE_PASSWORD']
        end
      end

      def self.load_users(tns)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.new.token
          req.params['search'] = "personnelNo=in=(#{tns.join(', ')})"
        end
      end

      def self.load_users_like(field, str)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.new.token
          req.params['search'] = "#{field}=='*#{str}*'"
        end
      end
    end
  end
end
