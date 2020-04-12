module Api
  module V1
    module Categories
      class CategoryOperatorSerializer < CategoryBaseSerializer
        has_many :services, if: :include_associations?, serializer: Services::ServiceResponsibleUserSerializer
        has_many :faq, if: :include_associations?, serializer: Tickets::TicketResponsibleUserSerializer do |serializer|
          query = QuestionTicketsQuery.new(serializer.object.tickets.includes(:responsible_users, answers: :attachments))
          query.most_popular.includes(:service)
        end
      end
    end
  end
end
