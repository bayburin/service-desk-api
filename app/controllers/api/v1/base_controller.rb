module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      # before_action :authenticate_user!

      protected

      def access_token
        request.headers['Authorization'].to_s.remove('Bearer ')
      end
    end
  end
end
