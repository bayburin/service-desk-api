module Api
  module V1
    class BaseController < ApplicationController
      def search
        render json: ThinkingSphinx.search(params[:search], order: 'popularity DESC')
      end
    end
  end
end
