module Api
  module V1
    class AnswersController < BaseController
      impressionist

      def download_attachment
        attachment = Answer.find(params[:id]).attachments.find(params[:attachment_id])

        send_file attachment.document.file.file
      end
    end
  end
end
