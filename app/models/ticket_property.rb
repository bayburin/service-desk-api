class TicketProperty
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :ticket_id, type: Integer
end
