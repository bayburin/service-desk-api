module Api
  module V1
    class TicketableForm < Reform::Form
      property :ticket, form: TicketForm, populate_if_empty: Ticket

      validate :validate_ticket

      def validate(params)
        ticket&.populate_collections(params[:ticket]) if params[:ticket]

        super(params)
      end

      def save
        ::ActiveRecord::Base.transaction do
          super
        end
      end

      protected

      def validate_ticket
        errors.add(:ticket, ticket.errors) unless ticket.valid?
      end
    end
  end
end
