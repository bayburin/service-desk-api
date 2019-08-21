module Api
  module V1
    module Scope
      def by_popularity
        order(popularity: :desc)
      end

      def visible
        where(is_hidden: false)
      end

      def by_responsible(user)
        where(responsible_users: user.responsible_users)
      end
    end
  end
end
