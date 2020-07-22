module Api
  module V1
    module Search
      # Поиск по категориям
      class SearchCategories
        include Interactor

        def call
          (context.result ||= []).concat(
            ActiveModel::Serializer::CollectionSerializer.new(search_categories, serializer: Categories::CategoryGuestSerializer).as_json
          )
        end

        protected

        def search_categories
          context.categories = Category.search(
            ThinkingSphinx::Query.escape(context.term),
            order: 'popularity DESC',
            per_page: 1000
          ).each(&:without_associations!)
        end
      end
    end
  end
end
