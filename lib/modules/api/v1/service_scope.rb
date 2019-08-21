module Api
  module V1
    module ServiceScope
      include Scope

      def by_tickets_responsible(user)
        includes(:tickets).where(tickets: { responsible_users: user.responsible_users })
      end
    end
  end
end
