module Api
  module V1
    # Объект формы модели AnswerAttachment
    class AttachmentForm < Reform::Form
      property :id
      property :answer_id
      property :document

      validates :document, presence: true
    end
  end
end
