class QuestionTicketPolicy < TicketPolicy
  def attributes_for_search
    if user.one_of_roles?(:content_manager, :operator, :service_responsible)
      PolicyAttributes.new(
        serializer: Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer,
        sql_include: [ticket: [:responsible_users, service: :responsible_users]],
        serialize: ['ticket.responsible_users', 'ticket.service.responsible_users']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::QuestionTickets::QuestionTicketGuestSerializer,
        sql_include: [ticket: :service],
        serialize: ['ticket.service']
      )
    end
  end

  def attributes_for_deep_search
    if user.one_of_roles?(:content_manager, :operator, :service_responsible)
      PolicyAttributes.new(
        serializer: Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer,
        sql_include: [ticket: [:responsible_users, service: :responsible_users], answers: :attachments],
        serialize: ['ticket.responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::QuestionTickets::QuestionTicketGuestSerializer,
        sql_include: [ticket: :service],
        serialize: ['answers.attachments', 'ticket.service']
      )
    end
  end
end
