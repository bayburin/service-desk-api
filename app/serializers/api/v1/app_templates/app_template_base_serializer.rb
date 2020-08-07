module Api
  module V1
    module AppTemplates
      class AppTemplateBaseSerializer < ActiveModel::Serializer
        attributes :id, :description, :destination, :message, :info

        belongs_to :ticket, serializer: Api::V1::Tickets::TicketBaseSerializer
      end
    end
  end
end
