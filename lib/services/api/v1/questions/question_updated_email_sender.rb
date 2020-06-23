module Api
  module V1
    module Questions
      class QuestionUpdatedEmailSender
        def send(delivery_user, ticket, current_user, origin)
          ContentManagerMailer.question_updated_email(delivery_user, ticket, current_user, origin).deliver_now
        end
      end
    end
  end
end
