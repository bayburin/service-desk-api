module Api
  module V1
    module Categories
      class CategoryBaseSerializer < ActiveModel::Serializer
        include Pundit

        attributes :id, :name, :short_description, :icon_name, :popularity

        has_many :services, if: :include_associations?, serializer: Services::ServiceBaseSerializer
        has_many :faq, if: :include_associations?, serializer: Tickets::TicketSerializer

        def include_associations?
          !object.without_associations
        end

        def services
          policy_scope(object.services)
        end

        def faq
          QuestionsQuery.new(object.tickets).most_popular
        end
      end
    end
  end
end
