module Api
  module V1
    class TagsController < BaseController
      def index
        tags = if params[:search]
                 Tag.where('name LIKE :term', term: "#{params[:search]}%")
               else
                 Tag.all
               end

        render json: tags
      end

      def popular
        tags = Tag
                 .select('tags.*, COUNT(tags.id) as popularity')
                 .left_outer_joins(:tickets)
                 .where(tickets: { service_id: params[:service_id] })
                 .group('tags.id')
                 .order(popularity: :desc)
                 .limit(params[:limit])

        render json: tags, each_serializer: TagExtendedSerializer
      end
    end
  end
end
