module Api
  module V1
    module ServiceScope
      include Scope

      def by_tickets_responsible(user)
        left_outer_joins(:tickets).where(tickets: { responsible_users: user.responsible_users })
      end
    end
  end
end
