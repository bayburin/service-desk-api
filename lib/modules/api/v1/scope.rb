module Api
  module V1
    module Scope
      # Сортировка по популярности
      def by_popularity
        order(popularity: :desc)
      end

      # Показать видимые объекты
      def visible
        where(is_hidden: false)
      end

      # Показать объекты за которые отвечает user
      def by_responsible(user)
        where(responsible_users: user.responsible_users)
      end
    end
  end
end
