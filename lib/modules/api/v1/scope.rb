module Api
  module V1
    module Scope
      def by_popularity
        order(popularity: :desc)
      end
    end
  end
end
