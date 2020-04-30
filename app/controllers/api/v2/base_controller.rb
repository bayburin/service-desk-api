module Api
  module V2
    class BaseController < ApplicationController
      include Pundit

      before_action :sign_in_guest

      def sign_in_guest
        sign_in Role.find_by(name: :guest).users.first
      end

      def welcome
        render json: { message: 'v2' }
      end

      rescue_from Pundit::NotAuthorizedError do |_exception|
        render json: I18n.t('controllers.app.access_denied'), status: :forbidden
      end
    end
  end
end
