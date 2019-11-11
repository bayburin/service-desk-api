module Api
  module V1
    module Tickets
      class UpdatePublishedTicket
        include ActiveModel::Validations

        validates_with OnlyOneCorrectionValidator

        attr_reader :original, :ticket

        def initialize(original)
          @original = original
        end

        def correction
          original.correction
        end

        def update(attributes)
          return unless valid?

          cleared_attributes = process_attributes(attributes)
          @ticket = original.build_correction(cleared_attributes)
          ticket.state = :draft
          ticket.ticket_type = :question
          return true if ticket.save

          errors.merge!(ticket.errors)
          false
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
