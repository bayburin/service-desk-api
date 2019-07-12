require 'net/http'

module Api
  module V1
    class UsersController < BaseController
      def info
        # notification_count = EventLog.where('JSON_EXTRACT(body, "$.user_tn") = 17664').left_outer_joins(:readers).where(event_log_readers: { tn: nil }).count
        render json: current_user
      end

      def owns
        items = SvtApi.items(current_user).body
        services = ServicesQuery.new.allowed_to_create_case

        render json: UserOwns.new(items, services), serializer: UserOwnsSerializer
      end
    end
  end
end
