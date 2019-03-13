module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      def search
        render json: ThinkingSphinx.search(params[:search], order: 'popularity DESC')
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
