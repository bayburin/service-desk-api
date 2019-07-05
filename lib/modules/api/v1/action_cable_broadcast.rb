module Api
  module V1
    module ActionCableBroadcast
      def broadcast_to_user(user_tn, msg)
        ActionCable.server.broadcast "case/current_user_#{user_tn}", message: msg
      end
    end
  end
end
