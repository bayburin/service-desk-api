module Api
  module V1
    module QuestionTickets
      class UpdatePublishedQuestion
        include ActiveModel::Validations

        validates_with OnlyOneCorrectionValidator

        attr_reader :original, :question_ticket

        def initialize(original)
          @original = original
        end

        def correction
          original.correction
        end

        def update(attributes)
          return unless valid?

          cleared_attributes = process_attributes(attributes)
          @question_ticket = Tickets::TicketFactory.create(:question, cleared_attributes.merge!(original_id: original.id))
          return true if question_ticket.save

          errors.merge!(question_ticket.errors)
          false
        end

        protected

        def process_attributes(attributes)
          attachments = AnswerAttachment
                          .where(answer_id: attributes[:answers_attributes].map { |answer| answer[:id] })
                          .select(:id, :answer_id, :document)

          attributes[:id] = nil
          attributes[:ticket_attributes][:id] = nil
          attributes[:ticket_attributes][:ticketable_id] = nil
          attributes[:ticket_attributes][:responsible_users_attributes].each do |responsible|
            responsible[:id] = nil
            responsible[:responseable_id] = nil
          end
          attributes[:answers_attributes].each do |answer|
            answer[:attachments_attributes] ||= []
            answer[:attachments_attributes] << build_attachments(answer, attachments)
            answer[:attachments_attributes] = answer[:attachments_attributes].flatten.compact.each { |el| el.try(:permit!) }
            answer[:id] = nil
          end

          attributes
        end

        def build_attachments(answer, attachments)
          original_attachments = attachments.where(answer_id: answer[:id])
          return if original_attachments.empty?

          original_attachments.map do |original|
            new_attachment = AnswerAttachment.new.as_json
            new_attachment['document'] = File.open(original.document.file.file) if original.document.present?
            new_attachment
          end
        end
      end
    end
  end
end
