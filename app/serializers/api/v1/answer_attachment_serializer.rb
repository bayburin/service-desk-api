module Api
  module V1
    class AnswerAttachmentSerializer < ActiveModel::Serializer
      attributes :id, :answer_id, :filename

      def filename
        object.document.file.original_filename
      end
    end
  end
end
