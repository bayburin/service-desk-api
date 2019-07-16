class UserNotificationCountChannel < ApplicationCable::Channel
  include Api::V1::ActionCableBroadcast

  def subscribed
    stream_from "notification_count/current_user_#{current_user.tn}"
  end

  def get
    transmit(Api::V1::NotificationsQuery.new(current_user).unread.count)
  end
end
