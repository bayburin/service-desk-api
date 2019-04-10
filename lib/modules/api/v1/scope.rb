module Api
  module V1
    module Scope
      def by_popularity
        order('popularity DESC')
      end
    end
  end
end
