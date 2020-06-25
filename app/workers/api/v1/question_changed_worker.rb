module Api
  module V1
    class QuestionChangedWorker
      include Sidekiq::Worker

      def perform(ticket_id, current_user_tn, type, origin)
        manager_ids = UsersQuery.new.managers.pluck(:id)

        case type
        when 'create'
          notify_on_create(manager_ids, ticket_id, current_user_tn, origin)
        when 'update'
          notify_on_update(manager_ids, ticket_id, current_user_tn, origin)
        end
      end

      def notify_on_create(manager_ids, ticket_id, current_user_tn, origin)
        manager_ids.each do |manager_id|
          Api::V1::NotifyContentManagerOnCreateQuestion.perform_async(manager_id, ticket_id, current_user_tn, origin)
        end
      end

      def notify_on_update(manager_ids, ticket_id, current_user_tn, origin)
        manager_ids.each do |manager_id|
          Api::V1::NotifyContentManagerOnUpdateQuestion.perform_async(manager_id, ticket_id, current_user_tn, origin)
        end
      end
    end
  end
end
