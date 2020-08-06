module Api
  module V1
    module Reporter
      class QuestionUpdatedEmailSender
        def send(delivery_user, ticket, **params)
          ContentManagerMailer.question_updated_email(delivery_user, ticket, **params).deliver_now
        end
      end
    end
  end
end
