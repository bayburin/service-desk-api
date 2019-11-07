module Api
  module V1
    module Tickets
      class PublishedState < AbstractState
        def update(attributes)
          cleared_attributes = process_attributes(attributes)
          @object = @ticket.build_correction(cleared_attributes)
          object.state = :draft
          object.ticket_type = :question

          object.save
        end

        def publish
          raise 'Вопрос уже опубликован'
        end

        protected

        def process_attributes(attributes)
          attachments = AnswerAttachment
                          .where(answer_id: attributes[:answers_attributes].map { |answer| answer[:id] })
                          .select(:id, :answer_id, :document)

          attributes[:id] = nil
          attributes[:answers_attributes].each do |answer|
            answer[:attachments_attributes] ||= []
            answer[:attachments_attributes] << build_attachments(answer, attachments)
            answer[:attachments_attributes] = answer[:attachments_attributes].flatten.compact.each { |el| el.try(:permit!) }

            answer[:ticket] = nil
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
