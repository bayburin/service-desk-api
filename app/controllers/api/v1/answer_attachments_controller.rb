module Api
  module V1
    class AnswerAttachmentsController < BaseController
      def show
        attachment = Answer.find(params[:answer_id]).attachments.find(params[:id])

        send_file attachment.document.file.file
      rescue ActionController::MissingFile
        render status: :not_found
      end

      def create
        answer = Answer.find(params[:answer_id]).attachments.new(attachments_params)

        if answer.save
          render json: answer
        else
          render json: answer.errors, status: :unprocessable_entity
        end
      end

      protected

      def attachments_params
        params.permit(:id, :answer_id, :document)
      end
    end
  end
end
