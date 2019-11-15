module Api
  module V1
    class ResponsibleUsersController < BaseController
      def index
        authorize current_user, :responsible_user_access?
        data = Employees::Employee.new.load_users(JSON.parse(params[:tns]))
        details = data ? data['data'].map { |detail| Api::V1::ResponsibleUserDetails.new(detail) } : []

        render json: details
      end
    end
  end
end
