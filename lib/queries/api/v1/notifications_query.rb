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
          .order(id: :desc)
      end

      def unread
        all.order(id: :desc).left_outer_joins(:readers)
          .where("notification_readers.notification_id NOT IN (SELECT notification_id from notification_readers WHERE tn = #{current_user.tn}) OR notification_readers.notification_id IS NULL")
          .uniq
      end

      def last_notifications(limit = nil)
        all.order(id: :desc).limit(limit)
      end
    end
  end
end
