module Api
  module V1
    module Search
      # Поиск по услугам
      class SearchServices
        include Interactor

        def call
          context.services = ServicePolicy::SphinxScope.new(context.user, search_services).resolve
          (context.result ||= []).concat(
            ActiveModel::Serializer::CollectionSerializer.new(context.services, serializer: Services::ServiceGuestSerializer)
              .as_json(include: policy.serialize)
          )
        end

        protected

        def search_services
          context.services = Service.search(
            ThinkingSphinx::Query.escape(context.term),
            order: 'popularity DESC',
            per_page: 1000,
            sql: { include: policy.sql_include }
          )
        end

        def policy
          @policy ||= ServicePolicy.new(context.user, Service).attributes_for_search
        end
      end
    end
  end
end
