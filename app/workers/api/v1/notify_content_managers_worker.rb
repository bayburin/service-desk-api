module Api
  module V1
    class NotifyContentManagersWorker
      include Sidekiq::Worker

      def perform(ticket_id, current_user_id, type, origin)
        manager_ids = UsersQuery.new.managers.pluck(:id)

        case type
        when 'create'
          notify_on_create(manager_ids, ticket_id, current_user_id, origin)
        when 'update'
          notify_on_update(manager_ids, ticket_id, current_user_id, origin)
        end
      end

      def notify_on_create(manager_ids, ticket_id, current_user_id, origin)
        manager_ids.each do |manager_id|
          Api::V1::NotifyContentManagerOnCreate.perform_async(manager_id, ticket_id, current_user_id, origin)
        end
      end

      def notify_on_update(manager_ids, ticket_id, current_user_id, origin)
        manager_ids.each do |manager_id|
          Api::V1::NotifyContentManagerOnUpdate.perform_async(manager_id, ticket_id, current_user_id, origin)
        end
      end
    end
  end
end
