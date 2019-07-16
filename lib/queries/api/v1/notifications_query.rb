module Api
  module V1
    class NotificationsQuery < ApplicationQuery
      def initialize(current_user, scope = Notification.all)
        @current_user = current_user
        @scope = scope
      end

      def all
        scope
          .where(event_type: :case, tn: current_user.tn)
          .or(Notification.where(event_type: :broadcast, tn: nil))
      end

      def unread
        all.left_outer_joins(:readers).where(notification_readers: { tn: nil })
      end

      def last_notifications(limit = nil)
        all.order(id: :desc).limit(limit)
      end
    end
  end
end
