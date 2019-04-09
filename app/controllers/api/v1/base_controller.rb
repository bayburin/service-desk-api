module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      # Обрабтка случаев, когда у пользователя нет доступа на выполнение запрашиваемых действий
      rescue_from Pundit::NotAuthorizedError do |_exception|
        render json: { full_message: I18n.t('controllers.app.access_denied') }, status: :forbidden
      end

      protected

      def current_user
        UserIss.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def doorkeeper_unauthorized_render_options(error: nil)
        { json: { message: I18n.t('doorkeeper.authorizations.new.title') } }
      end
    end
  end
end
