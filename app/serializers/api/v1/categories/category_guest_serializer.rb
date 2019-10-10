module Api
  module V1
    module Categories
      class CategoryGuestSerializer < CategoryBaseSerializer
        has_many :services, if: :include_associations?, serializer: Services::ServiceGuestSerializer do |serializer|
          ServicesQuery.new(serializer.object.services).visible
        end
        has_many :faq, if: :include_associations?, serializer: Tickets::TicketGuestSerializer
      end
    end
  end
end
