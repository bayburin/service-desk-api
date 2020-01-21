module Api
  module V1
    class ReportSender
      def initialize(delivery_user, object, current_user, origin)
        @delivery_user = delivery_user
        @object = object
        @current_user = current_user
        @origin = origin
      end

      def send_report(sender)
        sender.send(@delivery_user, @object, @current_user, @origin)
      end
    end
  end
end
