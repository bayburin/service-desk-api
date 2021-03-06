class QuestionPolicy < TicketPolicy
  def attributes_for_search
    if user.one_of_roles?(:content_manager, :operator, :service_responsible)
      PolicyAttributes.new(
        serializer: Api::V1::Questions::QuestionResponsibleUserSerializer,
        sql_include: [ticket: [:responsible_users, service: :responsible_users]],
        serialize: ['ticket.responsible_users', 'ticket.service.responsible_users']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Questions::QuestionGuestSerializer,
        sql_include: [ticket: :service],
        serialize: ['ticket.service']
      )
    end
  end

  def attributes_for_deep_search
    if user.one_of_roles?(:content_manager, :operator, :service_responsible)
      PolicyAttributes.new(
        serializer: Api::V1::Questions::QuestionResponsibleUserSerializer,
        sql_include: [ticket: [:responsible_users, service: :responsible_users], answers: :attachments],
        serialize: ['ticket.responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Questions::QuestionGuestSerializer,
        sql_include: [ticket: :service],
        serialize: ['answers.attachments', 'ticket.service']
      )
    end
  end

  def attributes_for_show
    PolicyAttributes.new(
      serializer: Api::V1::Questions::QuestionResponsibleUserSerializer,
      sql_include: [:correction, ticket: %i[service responsible_users tags ticket_tags], answers: :attachments],
      serialize: [
        'correction.*', 'correction.ticket.responsible_users', 'correction.ticket.service', 'correction.ticket.tags',
        'correction.answers.attachments', 'ticket.responsible_users', 'ticket.tags', 'ticket.service', 'answers.attachments'
      ]
    )
  end
end
