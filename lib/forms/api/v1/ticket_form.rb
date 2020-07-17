module Api
  module V1
    # Объект формы модели Ticket
    class TicketForm < Reform::Form
      property :id
      property :identity, default: ->(**) { Ticket.generate_identity }
      property :service_id
      property :name
      property :ticketable
      property :state, default: ->(**) { :draft }
      property :is_hidden
      property :sla
      property :to_approve
      property :popularity
      collection :responsible_users, form: ResponsibleUserForm, populate_if_empty: ResponsibleUser, populator: :populate_responsible_users!
      collection :tags, form: TagForm, populate_if_empty: Tag, populator: :populate_tags!

      validates :name, :identity, presence: true
      validate :validate_tags
      validate :validate_responsible_users

      # Обработывает полученный список тэгов и удаляет из объекта tags отсутствующие
      def populate_collections(params)
        # Список тегов, которые привязаны в базе, но не были найдены в полученных данных
        tags_to_remove = tags.map do |tag|
          next if params[:tags].any? { |t_param| t_param[:id].to_i == tag.id }

          tag
        end.compact

        tags_to_remove.each { |tag| tags.delete(tag) }
      end

      protected

      # Обработка тэгов
      def populate_tags!(fragment:, **)
        item = tags.find { |tag| tag.id == fragment[:id].to_i }
        # ? Пока ticket содержит объект tags не получится добавить флаг :_destroy.
        # ? Если будет вложенность ticket_tags -> tag, можно будет использвать флаг :_destroy
        # if fragment[:_destroy].to_s == 'true'
        #   responsible_users.delete(item)
        #   return skip!
        # end
        return item if item

        tag = Tag.find_by('id = ? or name = ?', fragment[:id], fragment[:name]) || Tag.new(name: fragment[:name])
        tags.append(tag)
      end

      # Обработка ответственных
      def populate_responsible_users!(fragment:, **)
        item = responsible_users.find { |user| user.id == fragment[:id].to_i }

        if fragment[:_destroy].to_s == 'true'
          responsible_users.delete(item)
          return skip!
        end

        item || responsible_users.append(ResponsibleUser.new)
      end

      # Валидация формы тегов
      def validate_tags
        errors.add(:base, 'Проверьте корректность введенных тегов') unless tags.all?(&:valid?)
      end

      # Валидация формы ответственных
      def validate_responsible_users
        errors.add(:base, 'Проверьте корректность ответственных') unless responsible_users.all?(&:valid?)
      end
    end
  end
end
