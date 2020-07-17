module Api
  module V1
    module Questions
      # Создание чернового варианта для опубликованного вопроса.
      class UpdatePublishedForm < QuestionForm
        attr_reader :original_model

        def initialize(original_model)
          # Оригинальный объект Question
          @original_model = original_model

          # Передается новый объект Question, чтобы для текущего опубликованного вопроса в БД создался новый экземпляр черновика с ссылкой
          # на оригинал.
          super(Question.new)
        end

        def validate(params)
          super(params)

          self.original_id = original_model.id
          ticket.identity = original_model.ticket.identity
          copy_files
          nullify_ids
        end

        protected

        # Скопировать в черновик файлы из оригинала, если это необходимо.
        # Внимание! Этот метод необходимо запускать ДО #nullify_ids, пока не утеряны id ответов.
        def copy_files
          answers.each do |answer|
            answer.populate_attachments(attachments.where(answer_id: answer.id))
          end
        end

        # Получить список файлов, прикрепленных к ответам опубликованного вопроса
        def attachments
          @attachments ||= AnswerAttachment
                             .where(answer_id: answers.map(&:id))
                             .select(:id, :answer_id, :document)
        end

        # Сбросить id у всех объектов форм, чтобы в БД появились новые записи, а оригинал остался нетронутым
        def nullify_ids
          self.id = nil
          answers.each { |answer| answer.id = nil }
          ticket.id = nil
          ticket.responsible_users.each do |u|
            u.id = nil
            u.responseable_id = nil
          end
        end
      end
    end
  end
end
