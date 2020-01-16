module Api
  module V1
    class ReportSender
      def initialize(delivery_user, object, current_user)
        @delivery_user = delivery_user
        @object = object
        @current_user = current_user
      end

      def send_report(sender)
        sender.send(@delivery_user, @object, @current_user)
      end
    end
  end
end
