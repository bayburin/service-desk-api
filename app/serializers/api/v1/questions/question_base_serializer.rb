module Api
  module V1
    module Questions
      class QuestionBaseSerializer < ActiveModel::Serializer
        attributes :id, :original_id

        has_many :answers, if: :include_associations?, serializer: AnswerSerializer

        belongs_to :ticket, serializer: Api::V1::Tickets::TicketBaseSerializer

        def include_associations?
          !object.without_associations
        end
      end
    end
  end
end
