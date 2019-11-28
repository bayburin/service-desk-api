module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      before_action :authenticate_user!

      def welcome
        render :nothing
      end

      rescue_from Pundit::NotAuthorizedError do |_exception|
        render json: I18n.t('controllers.app.access_denied'), status: :forbidden
      end
    end
  end
end
