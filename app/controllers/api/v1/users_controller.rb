require 'net/http'

module Api
  module V1
    class UsersController < BaseController
      before_action :doorkeeper_authorize!

      def info
        @user_info = ::Api::V1::Doorkeeper::UserInfo.new(doorkeeper_token)

        if @user_info.run
          render json: @user_info.data
        else
          render json: { message: @user_info.errors.full_messages.join('. ') }, status: @user_info.error[:status]
        end
      end

      def owns
        items = Svt::SvtApi.items(current_user).body
        services = Service.extend(Scope).visible

        render json: UserOwns.new(items, services), serializer: UserOwnsSerializer
      end
    end
  end
end
