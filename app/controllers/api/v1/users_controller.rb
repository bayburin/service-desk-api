require 'net/http'

module Api
  module V1
    class UsersController < BaseController
      def info
        render json: current_user
      end

      def owns
        items = SvtApi.items(current_user).body
        services = ServicesQuery.new.allowed_to_create_case

        render json: UserOwns.new(items, services), serializer: UserOwnsSerializer
      end

      def notifications
        render json: current_user.notifications.order(id: :desc).limit(params[:limit])
      end
    end
  end
end
