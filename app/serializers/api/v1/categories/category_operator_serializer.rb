module Api
  module V1
    module Categories
      class CategoryOperatorSerializer < CategoryBaseSerializer
        has_many :services, if: :include_associations?, serializer: Services::ServiceResponsibleUserSerializer
        has_many :faq, if: :include_associations?, serializer: QuestionTickets::QuestionTicketResponsibleUserSerializer do |serializer|
          query = QuestionTicketsQuery.new(serializer.object.question_tickets.includes(ticket: :responsible_users, answers: :attachments))
          query.most_popular
          # .includes(:service)
        end
      end
    end
  end
end
