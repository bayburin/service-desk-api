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
        read_notifications

        render json: NotificationsQuery.new(current_user).last_notifications(params[:limit])
      end

      def new_notifications
        render json: read_notifications.first(params[:limit].to_i || nil)
      end

      private

      def read_notifications
        decorated_user = UserDecorator.new(current_user)
        decorated_user.read_notifications
      end
    end
  end
end
