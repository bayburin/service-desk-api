module Api
  module V1
    class ResponsibleUsersController < BaseController
      before_action :authorize_ctrl

      def index
        data = Employees::Employee.new(:exact).load_users(tns: JSON.parse(params[:tns]))
        details = data ? data['data'].map { |detail| Api::V1::ResponsibleUserDetails.new(detail) } : []

        render json: details
      end

      def search
        data = Employees::Employee.new(:like).load_users(params)
        details = data ? data['data'].map { |detail| Api::V1::ResponsibleUserDetails.new(detail) } : []

        render json: details
      end

      protected

      def authorize_ctrl
        authorize current_user, :responsible_user_access?
      end
    end
  end
end
