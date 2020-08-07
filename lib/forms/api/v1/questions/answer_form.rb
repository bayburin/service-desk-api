module Api
  module V1
    module Questions
      # Объект формы модели Answer
      class AnswerForm < Reform::Form
        property :id
        property :question_id
        property :answer
        property :link
        property :is_hidden
        collection :attachments, form: AttachmentForm, populate_if_empty: AnswerAttachment

        validates :answer, presence: true

        # Добавляет файлы к ответу
        def populate_attachments(original_files)
          original_files.each do |file|
            document = File.open(file.document.file.file) if file.document.present?
            attachments.append(AnswerAttachment.new(document: document)) if document
          end
        end
      end
    end
  end
end
