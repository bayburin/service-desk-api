module Api
  module V1
    class UsersController < BaseController
      before_action :doorkeeper_authorize!

      def info
        @user_info = Doorkeeper::UserInfo.new(doorkeeper_token)

        if @user_info.run
          render json: @user_info.data
        else
          render json: { message: @user_info.errors.full_messages.join('. ') }, status: @user_info.error[:status]
        end
      end
    end
  end
end
