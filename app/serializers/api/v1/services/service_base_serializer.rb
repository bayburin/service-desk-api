module Api
  module V1
    module Services
      class ServiceBaseSerializer < ActiveModel::Serializer
        attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

        has_many :tickets, if: :include_associations?, serializer: Tickets::TicketSerializer
        has_many :responsible_users, if: :include_associations?

        belongs_to :category, if: :include_associations?, serializer: Categories::CategoryBaseSerializer

        def include_associations?
          !object.without_associations
        end

        def include_authorize_attributes_for(tickets_scope)
          includes_options = instance_options[:authorize_attributes] || {}
          tickets_scope = tickets_scope.includes(includes_options) unless object.tickets.any?(&:without_associations)

          tickets_scope
        end
      end
    end
  end
end
