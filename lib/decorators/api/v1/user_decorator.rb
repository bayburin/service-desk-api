module Api
  module V1
    class UserDecorator < SimpleDelegator
      def initialize(user)
        __setobj__ user
      end

      def read_notifications
        notifications = Api::V1::NotificationsQuery.new(__getobj__).unread
        notifications.each do |notify|
          notify.readers.create(user: __getobj__, tn: tn)
        end
      end
    end
  end
end
