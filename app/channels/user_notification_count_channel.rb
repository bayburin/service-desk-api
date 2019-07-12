class UserNotificationCountChannel < ApplicationCable::Channel
  include Api::V1::ActionCableBroadcast

  def subscribed
    stream_from "notification_count/current_user_#{current_user.tn}"
  end

  def get
    transmit(current_user.new_notifications.count)
  end
end
