class CaseChannel < ApplicationCable::Channel
  def subscribed
    stream_from "case/current_user_#{current_user.tn}"
  end
end
