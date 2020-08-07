module Api
  module V1
    module AppTemplates
      # Объект формы модели AppTemplate
      class AppTemplateForm < TicketableForm
        property :id
        property :description
        property :destination
        property :message
        property :info
      end
    end
  end
end
