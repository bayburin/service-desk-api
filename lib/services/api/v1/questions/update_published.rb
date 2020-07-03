module Api
  module V1
    module Questions
      class UpdatePublished < ApplicationService
        validates_with OnlyOneCorrectionValidator

        attr_reader :original, :question

        def initialize(original, params)
          @original = original
          @params = params

          super
        end

        def correction
          original.correction
        end

        def call
          return unless valid?

          process_attributes
          @question = Tickets::TicketFactory.create(:question, params.merge!(original_id: original.id))

          Rails.logger.debug { "Correction: #{question.ticket.inspect}".cyan }
          return true if question.save

          errors.merge!(question.errors)
          false
        end

        protected

        def process_attributes
          attachments = AnswerAttachment
                          .where(answer_id: params[:answers_attributes].map { |answer| answer[:id] })
                          .select(:id, :answer_id, :document)

          params[:id] = nil
          params[:ticket_attributes][:id] = nil
          params[:ticket_attributes][:ticketable_id] = nil
          params[:ticket_attributes][:identity] = original.ticket.identity
          params[:ticket_attributes][:responsible_users_attributes].each do |responsible|
            responsible[:id] = nil
            responsible[:responseable_id] = nil
          end
          params[:answers_attributes].each do |answer|
            answer[:attachments_attributes] ||= []
            answer[:attachments_attributes] << build_attachments(answer, attachments)
            answer[:attachments_attributes] = answer[:attachments_attributes].flatten.compact.each { |el| el.try(:permit!) }
            answer[:id] = nil
          end
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
