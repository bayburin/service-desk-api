module Api
  module V1
    module Scope
      def by_popularity
        order(popularity: :desc)
      end

      def visible
        where(is_hidden: false)
      end
    end
  end
end
