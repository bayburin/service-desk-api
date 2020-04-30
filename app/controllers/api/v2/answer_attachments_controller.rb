module Api
  module V2
    class AnswerAttachmentsController < BaseController
      def show
        attachment = Answer.find(params[:answer_id]).attachments.find(params[:id])
        authorize attachment

        send_file attachment.document.file.file
      rescue ActionController::MissingFile
        render status: :not_found
      end
    end
  end
end
