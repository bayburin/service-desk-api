module Api
  module V1
    class ReportSender
      def initialize(delivery_user, object, **params)
        @delivery_user = delivery_user
        @object = object
        @params = params
      end

      def send_report(sender)
        sender.send(@delivery_user, @object, **@params)
      end
    end
  end
end
