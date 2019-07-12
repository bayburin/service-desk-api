module Api
  module V1
    module ActionCableBroadcast
      def broadcast_notification_to_user(user_tn, msg)
        ActionCable.server.broadcast "notify/current_user_#{user_tn}", msg
      end

      def broadcast_notification_count(user_tn, count)
        ActionCable.server.broadcast "notification_count/current_user_#{user_tn}", count
      end
    end
  end
end
