class UserNotifyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notify/current_user_#{current_user.tn}"
  end
end
