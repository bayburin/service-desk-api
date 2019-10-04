module Api
  module V1
    class AnswerAttachmentsController < BaseController
      def show
        attachment = Answer.find(params[:answer_id]).attachments.find(params[:id])
        authorize attachment

        send_file attachment.document.file.file
      rescue ActionController::MissingFile
        render status: :not_found
      end

      def create
        attachment = Answer.find(params[:answer_id]).attachments.new(attachments_params)
        authorize attachment

        if attachment.save
          render json: attachment
        else
          render json: attachment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        attachment = Answer.find(params[:answer_id]).attachments.find(params[:id])
        authorize attachment

        if attachment.destroy
          render json: attachment
        else
          render json: attachment.errors, status: :unprocessable_entity
        end
      end

      protected

      def attachments_params
        params.permit(:answer_id, :document)
      end
    end
  end
end
