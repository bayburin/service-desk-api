module Api
  module V1
    class UsersController < BaseController
      def info
        render json: current_user
      end

      def owns
        items = SvtApi.items(current_user).body
        services = ServicesQuery.new.allowed_to_create_app

        render json: UserOwns.new(items, services)
      end

      def notifications
        read_notifications

        render json: NotificationsQuery.new(current_user).last_notifications(params[:limit])
      end

      def new_notifications
        limit = params[:limit].to_i.zero? ? UserDecorator::NOTIFICATION_MAX_LENGTH : params[:limit].to_i
        render json: read_notifications.first(limit)
      end

      private

      def read_notifications
        decorated_user = UserDecorator.new(current_user)
        decorated_user.read_notifications
      end
    end
  end
end
