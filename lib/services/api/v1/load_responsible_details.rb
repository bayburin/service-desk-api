module Api
  module V1
    class LoadResponsibleDetails
      def initialize(tickets)
        @tickets = tickets
      end

      def load_details
        numbers = @tickets.map { |t| t.responsible_users.map(&:tn) }.flatten
        @details = Employees::Employee.new.load_users(numbers)
      end

      def associate_details!
        @tickets.each do |ticket|
          ticket.responsible_users.each do |user|
            user_detail = @details['data'].find { |detail| user.tn == detail['personnelNo'] }
            user.details = user_detail if user_detail
          end
        end
      end
    end
  end
end
