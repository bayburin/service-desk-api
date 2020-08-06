module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = CategoriesQuery.new.all.limit(9)
        services = ServicesQuery.new.most_popular.includes(:questions).each do |service|
          service.questions.each(&:without_associations!)
        end
        user_recommendations = UserRecommendation.order(:order)

        render(
          json: Dashboard.new(categories, services, user_recommendations),
          serializer: DashboardSerializer,
          include: 'categories,services.questions,user_recommendations'
        )
      end

      def search
        search = Search::Search.call(user: current_user, term: params[:search].strip)
        ahoy.track(
          Ahoy::Event::TYPES[:search_result],
          term: params[:search].strip,
          found: search.result.count,
          found_categories: search.categories.count,
          found_services: search.services.count,
          found_questions: search.questions.count
        )

        render json: search.result
      end

      def deep_search
        deep_search = Search::DeepSearch.call(user: current_user, term: params[:search].strip)
        ahoy.track(
          Ahoy::Event::TYPES[:deep_search_result],
          term: params[:search].strip,
          found: deep_search.result.count,
          found_categories: deep_search.categories.count,
          found_services: deep_search.services.count,
          found_questions: deep_search.questions.count
        )

        render json: deep_search.result
      end
    end
  end
end
