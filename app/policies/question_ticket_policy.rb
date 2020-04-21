class QuestionTicketPolicy < TicketPolicy
  def attributes_for_deep_search
    if user.one_of_roles?(:content_manager, :operator, :service_responsible)
      PolicyAttributes.new(
        serializer: Api::V1::Tickets::TicketResponsibleUserSerializer,
        sql_include: [:responsible_users, service: :responsible_users, answers: :attachments],
        serialize: ['responsible_users', 'service.responsible_users', 'answers.attachments']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::QuestionTickets::QuestionTicketGuestSerializer,
        sql_include: [ticket: :service, answers: :attachments],
        serialize: ['answers.attachments', 'ticket.service']
      )
    end
  end
end
