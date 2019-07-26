module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      before_action :authenticate_user!

      def welcome
        render :nothing
      end
    end
  end
end
