module Api
  module V1
    class NotifyContentManagersWorker
      include Sidekiq::Worker

      def perform(ticket_id, current_user_id)
        UsersQuery.new.managers.pluck(:id).each do |user_id|
          Api::V1::NotifyContentManagerWorker.perform_async(user_id, ticket_id, current_user_id)
        end
      end
    end
  end
end
