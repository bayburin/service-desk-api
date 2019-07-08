module Api
  module V1
    module ActionCableBroadcast
      def broadcast_to_user(user_tn, msg)
        ActionCable.server.broadcast "notify/current_user_#{user_tn}", msg
      end
    end
  end
end
